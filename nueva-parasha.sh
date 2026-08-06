#!/usr/bin/env bash
# Publica la parasha de la semana en un solo paso.
#
#   ./nueva-parasha.sh <slug> <anio-hebreo> [--nombre "Ree"] [--titulo "Ree: ..."]
#
# Ejemplo:
#   ./nueva-parasha.sh ree 5786 --nombre "Ree" --titulo "Ree: la vision que se elige"
#
# Que hace, en orden:
#   1. Crea /parasha/<slug>-<anio>/index.html a partir de la entrega vigente,
#      con canonical, og:url y JSON-LD (@id, url, mainEntityOfPage) ya apuntando
#      al permalink nuevo y datePublished con la fecha de hoy.
#   2. Marca la entrega saliente como archivada (banda .archivo-aviso).
#   3. Apunta el redirect 302 de /parasha/ en vercel.json al permalink nuevo.
#   4. Anade la entrada al ItemList y al listado visible de /parasha/archivo/.
#   5. Regenera sitemap.xml con ./generar-sitemap.sh.
#   6. Imprime el comando de IndexNow y el orden de publicacion.
#
# NO redacta el comentario: deja marcadores TODO visibles en el cuerpo del
# articulo. La pagina no debe publicarse hasta que un humano los sustituya;
# el script avisa de cuantos quedan.
#
# Requiere bash + git + perl (los tres vienen con Git for Windows). Sin build.

set -euo pipefail
cd "$(dirname "$0")"

# ---------------------------------------------------------------- argumentos
uso() {
  sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-1}"
}

[ $# -ge 2 ] || uso 1
SLUG="$1"; ANIO="$2"; shift 2
NOMBRE=""; TITULO=""
while [ $# -gt 0 ]; do
  case "$1" in
    --nombre) NOMBRE="${2:?falta el valor de --nombre}"; shift 2 ;;
    --titulo) TITULO="${2:?falta el valor de --titulo}"; shift 2 ;;
    -h|--help) uso 0 ;;
    *) echo "Argumento desconocido: $1" >&2; uso 1 ;;
  esac
done

case "$SLUG" in
  *[!a-z0-9-]*|"") echo "El slug solo admite minusculas, digitos y guiones: '$SLUG'" >&2; exit 1 ;;
esac
case "$ANIO" in
  [0-9][0-9][0-9][0-9]) ;;
  *) echo "El anio hebreo debe tener 4 digitos: '$ANIO'" >&2; exit 1 ;;
esac

[ -n "$NOMBRE" ] || NOMBRE="$(printf '%s' "${SLUG%%-*}" | sed 's/^./\U&/')"
[ -n "$TITULO" ] || TITULO="TODO — titulo de $NOMBRE"

DIR="parasha/${SLUG}-${ANIO}"
NUEVO="/parasha/${SLUG}-${ANIO}/"
HOST="https://zoharlatinoamerica.site"
HOY="$(date +%F)"

[ ! -e "$DIR" ] || { echo "Ya existe $DIR — no lo sobrescribo." >&2; exit 1; }

# ------------------------------------------------- entrega vigente (la saliente)
ACTUAL=$(perl -0ne 'print $1 if m{"source":\s*"/parasha/",\s*"destination":\s*"([^"]+)"}' vercel.json)
[ -n "$ACTUAL" ] || { echo "No encuentro el redirect de /parasha/ en vercel.json." >&2; exit 1; }
FUENTE=".${ACTUAL}index.html"
[ -f "$FUENTE" ] || { echo "El redirect apunta a $ACTUAL pero no existe $FUENTE." >&2; exit 1; }
# Nombre corto de la entrega saliente: el h1 sin el subtitulo tras los dos puntos.
NOMBRE_ACTUAL=$(perl -0ne 'print $1 if m{<header class="cabecera">.*?<h1>(.*?)</h1>}s' "$FUENTE" \
  | sed -e 's/<[^>]*>//g' -e 's/:.*$//' -e 's/[[:space:]]*$//')
# Anio hebreo de la entrega saliente (del propio slug), que no siempre es el nuevo.
ANIO_ACTUAL=$(printf '%s' "${ACTUAL%/}" | sed 's/.*-//')

echo "Entrega saliente : $ACTUAL  ($NOMBRE_ACTUAL)"
echo "Entrega nueva    : $NUEVO   ($TITULO)"
echo

# ------------------------------------------------------------- 1. pagina nueva
mkdir -p "$DIR"
SLUG="$SLUG" ANIO="$ANIO" NOMBRE="$NOMBRE" TITULO="$TITULO" NUEVO="$NUEVO" \
HOST="$HOST" HOY="$HOY" ACTUAL="$ACTUAL" NOMBRE_ACTUAL="$NOMBRE_ACTUAL" \
perl -0pe '
  my ($nuevo,$host,$hoy)   = (@ENV{qw(NUEVO HOST HOY)});
  my ($nombre,$titulo)     = (@ENV{qw(NOMBRE TITULO)});
  my ($actual,$nomactual)  = (@ENV{qw(ACTUAL NOMBRE_ACTUAL)});
  my $perma = "$host$nuevo";
  my $todo  = "TODO";

  # --- head: identidad de la pagina nueva
  s{<title>[^<]*</title>}{<title>Parashat $nombre $ENV{ANIO} — $todo | Zohar Latinoamérica</title>};
  s{(<meta name="description" content=")[^"]*}{$1$todo — resumen de $nombre $ENV{ANIO} en una o dos frases.};
  s{(<meta property="og:title" content=")[^"]*}{$1$titulo};
  s{(<meta property="og:description" content=")[^"]*}{$1$todo — resumen de $nombre para redes.};
  s{(<meta property="og:url" content=")[^"]*}{$1$perma};
  s{(<link rel="canonical" href=")[^"]*}{$1$perma};

  # --- JSON-LD: todo al permalink, nunca a /parasha/
  s{("\@id":\s*")[^"]*(#articulo")}{$1$perma$2};
  s{("headline":\s*")[^"]*}{$1$titulo};
  s{("description":\s*")[^"]*}{$1$todo — descripcion del articulo para datos estructurados.};
  s{("datePublished":\s*")[^"]*}{$1$hoy};
  s{("url":\s*")https://zoharlatinoamerica\.site/parasha/[^"]*}{$1$perma};
  s{("mainEntityOfPage":\s*")[^"]*}{$1$perma};

  # --- cabecera visible
  s{(<p class="hebreo-grande">)[^<]*}{$1TODO — nombre en hebreo};
  s{(<header class="cabecera">.*?<h1>).*?(</h1>)}{$1$titulo$2}s;
  s{(<p class="meta-linea">)[^<]*}{$1TODO — fecha hebrea · fecha civil · lectura · Haftara};

  # --- cuerpo: se vacia entero, del <article> al bloque de membresia.
  #     El comentario lo escribe un humano, no el script.
  s{(<article>\n).*?(\n  <div class="cta-membresia">)}
   {$1
  <p>TODO — comentario de la semana. Toda afirmacion con su fuente citada
  (Tanaj libro cap:vers, Rashi/Midrash, Zohar seccion, Talmud tratado y folio).
  Ninguna cita inventada: ante la duda, generalizar la referencia o quitarla.</p>

  <div class="archivo">
    <span class="etiqueta">Las semanas pasadas</span>
    <p>TODO — una o dos frases que enlacen esta entrega con la anterior.
    <a href="$actual">Leer el comentario de $nomactual &rarr;</a></p>
  </div>

  <div class="dato-ciclo">
    <p class="etiqueta">La posicion en el Gran Ciclo · solo aqui</p>
    <p>TODO — posicion del anio en el ciclo metonico y lectura del calendario.</p>
  </div>

  <p style="font-style:italic;color:#6b5d3f;">Shabat Shalom. TODO — linea de cierre.</p>
$2}s;

  # --- CTA y linea de fuentes
  s{(<h3>)[^<]*(</h3>)}{$1La guia completa de $nombre, en tu correo$2};
  s{(Fuentes de esta entrega:)[^·]*·[^<]*}{$1 TODO — listado de fuentes citadas.\n    };
' "$FUENTE" > "$DIR/index.html"

echo "  creado  $DIR/index.html"

# ------------------------------------------- 2. archivar la entrega saliente
if ! grep -q 'class="archivo-aviso"' "$FUENTE"; then
  NOMBRE_ACTUAL="$NOMBRE_ACTUAL" ANIO_ACTUAL="$ANIO_ACTUAL" perl -0pi -e '
    # CSS de la banda, si la pagina no la traia (era la entrega vigente)
    s{(\.archivo \{)}{.archivo-aviso {\n  background: var(--hueso); border-bottom: 1px solid rgba(184,146,42,.35);\n  text-align: center; padding: .8rem 1.2rem;\n  font-family: '"'"'Source Sans 3'"'"', sans-serif; font-size: .82rem; letter-spacing: .03em;\n}\n.archivo-aviso a { font-weight: 600; }\n$1};
    s{(\n<header class="cabecera">)}{\n<p class="archivo-aviso">Esta es la entrega archivada de $ENV{NOMBRE_ACTUAL} ($ENV{ANIO_ACTUAL}). <a href="/parasha/">Lee la parashá de esta semana &rarr;</a></p>\n$1};
  ' "$FUENTE"
  echo "  archivada $ACTUAL (banda de aviso anadida)"
else
  echo "  archivada $ACTUAL (ya tenia banda de aviso)"
fi

# --------------------------------------------- 3. redirect 302 de /parasha/
NUEVO="$NUEVO" perl -0pi -e '
  s{("source":\s*"/parasha/?",\s*"destination":\s*")[^"]*}{$1$ENV{NUEVO}}g;
' vercel.json
echo "  vercel.json: /parasha/ -> $NUEVO"

# ------------------------------- 4. archivo: ItemList + listado visible
ARCHIVO="parasha/archivo/index.html"
NUEVO="$NUEVO" HOST="$HOST" NOMBRE="$NOMBRE" ANIO="$ANIO" TITULO="$TITULO" perl -0pi -e '
  my ($nuevo,$host,$nombre,$anio,$titulo) = (@ENV{qw(NUEVO HOST NOMBRE ANIO TITULO)});

  # ItemList: entra en posicion 1 y se renumera todo el bloque.
  s{("itemListElement":\s*\[\n)}
   {$1        {\n          "\@type": "ListItem",\n          "position": 1,\n          "url": "$host$nuevo",\n          "name": "$nombre ($anio)"\n        },\n};
  my $n = 0;
  s{("position":\s*)\d+}{$1 . ++$n}ge;

  # Listado visible: la ficha anterior deja de ser "esta semana".
  s{<a class="entrada actual" href="([^"]+)">\s*\n\s*<span class="etiqueta-actual">[^<]*</span>\n}
   {<a class="entrada" href="$1">\n}s;

  # Ficha nueva al principio del listado.
  s{(<main>\n\n)}
   {$1  <a class="entrada actual" href="$nuevo">\n    <span class="etiqueta-actual">Esta semana</span>\n    <p class="heb">TODO — nombre en hebreo</p>\n    <h2>$titulo</h2>\n    <p class="meta">TODO — fecha hebrea · fecha civil</p>\n    <p class="resumen">TODO — resumen de dos lineas.</p>\n    <span class="flecha">Leer &rarr;</span>\n  </a>\n\n};
' "$ARCHIVO"
echo "  $ARCHIVO: ficha e ItemList actualizados"

# ------------------------------------------------------- 5. sitemap
echo
./generar-sitemap.sh

# ------------------------------------------------------- 6. que falta
PENDIENTES=$(grep -c 'TODO' "$DIR/index.html" || true)
PEND_ARCH=$(grep -c 'TODO' "$ARCHIVO" || true)

cat <<FIN

──────────────────────────────────────────────────────────────────────
Quedan $PENDIENTES marcadores TODO en $DIR/index.html
y $PEND_ARCH en $ARCHIVO. NO publiques hasta sustituirlos todos:

  grep -n TODO $DIR/index.html $ARCHIVO

Despues, en este orden:

  git add -A && git commit -m "content(parasha): archiva $NOMBRE_ACTUAL y publica $NOMBRE $ANIO"
  git push origin main
  # esperar a que Vercel termine el deploy (~1 min) y comprobar:
  curl -sSI $HOST/parasha/            # 307 -> $NUEVO
  curl -sSI $HOST$NUEVO               # 200
  ./generar-sitemap.sh --check        # sin diferencias
  ./indexnow.sh                       # avisa a Bing/Yandex
  # y en Search Console: Inspeccion de URL -> $HOST$NUEVO -> Solicitar indexacion
──────────────────────────────────────────────────────────────────────
FIN
