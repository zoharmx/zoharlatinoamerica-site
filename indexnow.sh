#!/usr/bin/env bash
# Notifica a Bing/Edge (y Yandex) que hay contenido nuevo o actualizado.
# Google NO usa IndexNow: para Google se usa Search Console.
#
#   ./indexnow.sh                        → envía todas las URLs del sitemap
#   ./indexnow.sh /parasha/              → envía solo esa ruta
#
# Ejecutar después de cada despliegue con contenido nuevo (p. ej. la parashá semanal).

set -euo pipefail

KEY="f38de7eee1394b659fc31a2aab1be64f34fc870a108f4ca6866a54da5b3be5d0"
HOST="zoharlatinoamerica.site"

if [ $# -gt 0 ]; then
  urls=()
  for path in "$@"; do
    urls+=("https://$HOST$path")
  done
else
  # Sin argumentos: toma las URLs del sitemap desplegado.
  mapfile -t urls < <(curl -s "https://$HOST/sitemap.xml" | grep -o '<loc>[^<]*</loc>' | sed 's|</\?loc>||g')
fi

if [ ${#urls[@]} -eq 0 ]; then
  echo "No se encontraron URLs que enviar." >&2
  exit 1
fi

list=$(printf '"%s",' "${urls[@]}" | sed 's/,$//')

echo "Enviando ${#urls[@]} URL(s) a IndexNow:"
printf '  %s\n' "${urls[@]}"

code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "https://api.indexnow.org/indexnow" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d "{\"host\":\"$HOST\",\"key\":\"$KEY\",\"keyLocation\":\"https://$HOST/$KEY.txt\",\"urlList\":[$list]}")

# 200 = OK, 202 = aceptado y pendiente de validar la clave.
if [ "$code" = "200" ] || [ "$code" = "202" ]; then
  echo "OK (HTTP $code)"
else
  echo "FALLÓ (HTTP $code)" >&2
  exit 1
fi
