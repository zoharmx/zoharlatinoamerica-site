#!/usr/bin/env bash
# Genera sitemap.xml a partir del contenido real del repo.
#
#   ./generar-sitemap.sh            → reescribe sitemap.xml
#   ./generar-sitemap.sh --check    → no escribe; falla si sitemap.xml esta desincronizado
#
# Reglas:
#   - Una <url> por cada index.html publicado (respetando cleanUrls + trailingSlash).
#   - <lastmod> = fecha del ultimo commit que toco ese archivo (git log -1 --format=%cs).
#     Nunca fechas escritas a mano: un lastmod falso ensena a Google a ignorarlos.
#   - /parasha/ NO entra: desde agosto 2026 es un redirect 302 al permalink de la
#     semana, y un sitemap no debe declarar URLs que no responden 200.
#
# No requiere build ni dependencias: bash + git.

set -euo pipefail

cd "$(dirname "$0")"

HOST="https://zoharlatinoamerica.site"
SALIDA="sitemap.xml"

# changefreq y priority por tipo de pagina (los valores historicos del sitio).
metadatos() {
  case "$1" in
    /)                      echo "weekly 1.0" ;;
    /ensayo/)               echo "monthly 0.9" ;;
    /biblioteca/)           echo "weekly 0.8" ;;
    /parasha/archivo/)      echo "weekly 0.7" ;;
    /parasha/*/)            echo "yearly 0.6" ;;
    *)                      echo "monthly 0.5" ;;
  esac
}

# Fecha del ultimo commit que toco el archivo. Si aun no esta en git
# (contenido nuevo sin commitear), usa la fecha de hoy y avisa.
fecha_de() {
  local ruta="$1" f
  f=$(git log -1 --format=%cs -- "$ruta" 2>/dev/null || true)
  if [ -z "$f" ]; then
    f=$(date +%F)
    echo "  aviso: $ruta no esta commiteado todavia; lastmod=$f (provisional)" >&2
  fi
  printf '%s' "$f"
}

# Todos los index.html publicables. Se excluye lo que no se despliega.
mapfile -t archivos < <(
  find . -name index.html -type f \
    -not -path './.git/*' \
    -not -path './.vercel/*' \
    -not -path './node_modules/*' \
    -not -path './Fable 5/*' \
  | sed 's|^\./||' | LC_ALL=C sort
)

if [ ${#archivos[@]} -eq 0 ]; then
  echo "No se encontro ningun index.html. Ejecuta el script desde la raiz del repo." >&2
  exit 1
fi

# ruta_html -> url  (cleanUrls: true, trailingSlash: true)
url_de() {
  local ruta="$1"
  case "$ruta" in
    index.html) echo "/" ;;
    */index.html) echo "/${ruta%/index.html}/" ;;
    *) echo "" ;;
  esac
}

entradas=()   # "url<TAB>lastmod<TAB>changefreq<TAB>priority"
for ruta in "${archivos[@]}"; do
  url=$(url_de "$ruta")
  [ -n "$url" ] || continue
  # /parasha/ es un redirect: nunca va al sitemap.
  [ "$url" != "/parasha/" ] || continue
  read -r freq prio <<<"$(metadatos "$url")"
  entradas+=("$url	$(fecha_de "$ruta")	$freq	$prio")
done

# Orden: portada, ensayo, biblioteca, archivo, y despues los permalinks de
# parasha de mas reciente a mas antiguo.
ordenadas=()
for fijo in "/" "/ensayo/" "/biblioteca/" "/parasha/archivo/"; do
  for e in "${entradas[@]}"; do
    [ "${e%%	*}" = "$fijo" ] && ordenadas+=("$e")
  done
done
while IFS= read -r e; do
  [ -n "$e" ] && ordenadas+=("$e")
done < <(
  for e in "${entradas[@]}"; do
    u="${e%%	*}"
    case "$u" in
      /parasha/*/) [ "$u" = "/parasha/archivo/" ] || echo "$e" ;;
    esac
  done | LC_ALL=C sort -t'	' -k2,2r -k1,1
)

tmp=$(mktemp)
{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
  for e in "${ordenadas[@]}"; do
    IFS='	' read -r url lastmod freq prio <<<"$e"
    echo '  <url>'
    echo "    <loc>${HOST}${url}</loc>"
    echo "    <lastmod>${lastmod}</lastmod>"
    echo "    <changefreq>${freq}</changefreq>"
    echo "    <priority>${prio}</priority>"
    echo '  </url>'
  done
  echo '</urlset>'
} > "$tmp"

if [ "${1:-}" = "--check" ]; then
  if diff -q "$SALIDA" "$tmp" >/dev/null 2>&1; then
    echo "sitemap.xml esta al dia (${#ordenadas[@]} URLs)."
    rm -f "$tmp"
  else
    echo "sitemap.xml esta desincronizado. Diferencias:" >&2
    diff "$SALIDA" "$tmp" >&2 || true
    rm -f "$tmp"
    exit 1
  fi
else
  mv "$tmp" "$SALIDA"
  echo "sitemap.xml regenerado con ${#ordenadas[@]} URLs:"
  for e in "${ordenadas[@]}"; do
    IFS='	' read -r url lastmod _ _ <<<"$e"
    printf '  %-40s %s\n' "$url" "$lastmod"
  done
fi
