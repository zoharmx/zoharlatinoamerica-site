# SEO — que "Zohar Latinoamérica" te encuentre

## El diagnóstico (17 julio 2026)

`site:zoharlatinoamerica.site` devuelve cero resultados: el sitio **no está indexado**.

La primera hipótesis era que Google no sabía que el sitio existía. **Era falsa.**
Search Console lo desmiente:

| URL | Estado en Google |
|---|---|
| `/` | **Rastreada: actualmente sin indexar** — último rastreo 17 jul 2026, 5:51 |
| `/ensayo/`, `/biblioteca/`, `/parasha/` | **Descubierta: actualmente sin indexar** — nunca rastreadas |

Google **rastreó la home el mismo día** y decidió no indexarla. La detectó por el
sitemap y como páginas de referencia el video de YouTube y la página de Facebook.
Es decir: el descubrimiento funciona; lo que falla es que Google **no considera el
sitio suficientemente valioso para indexarlo todavía**.

Esto es lo normal en un dominio nuevo sin autoridad, y es importante entenderlo bien:
ningún ajuste técnico lo fuerza. "Rastreada: actualmente sin indexar" se resuelve con
señales de calidad y autoridad — contenido con sustancia propia y enlaces entrantes
genuinos — no con más metadatos.

Buscar "Zohar Latinoamérica" hoy devuelve kabbalah.info, Kabbalah Centre y Amazon.
Ninguno compite por ese nombre exacto: es tu marca, y una vez indexado es muy ganable.
"Zohar" a secas es otra historia: competidores con años de autoridad, sin atajo técnico.

## Hecho

- **Datos estructurados (JSON-LD)** en las 4 páginas. La home declara
  `EducationalOrganization` + `WebSite` + `VideoObject`. El `sameAs` enlaza el canal
  de YouTube y la página de Facebook: eso es lo que permite a Google entender que
  sitio + canal + página son **una sola entidad**, que es el mecanismo que puede
  producir un Knowledge Panel. `/ensayo/` y `/parasha/` declaran `Article`,
  `/biblioteca/` declara `CollectionPage`.
- **`rel=canonical`** en las 4 páginas (antes no había ninguna).
- **`meta description` + Open Graph en `/ensayo/`**, que no tenía ninguna.
- **`sitemap.xml`** con `lastmod` real.
- **IndexNow**: clave publicada y las 4 URLs enviadas a Bing/Edge/Yandex (HTTP 200).
  Esto no requiere cuenta.
- **Google Search Console**: propiedad de **Dominio** `sc-domain:zoharlatinoamerica.site`
  verificada por DNS, bajo `zoharlatinoamerica@gmail.com`. Sitemap enviado (4 páginas
  descubiertas; el anterior, del builder de Hostinger, era de enero 2025 y descubría 0).
  Las 4 URLs enviadas a la cola de rastreo prioritaria.

## Pendiente

### 1. Google Analytics 4

`index.html` tiene el bloque GA4 comentado con el placeholder `G-XXXXXXXXXX`.
Crea la propiedad en analytics.google.com, sustituye el ID y descomenta.
Vercel Web Analytics ya está activo y no necesita nada.

## Publicar la parashá de la semana

Desde agosto de 2026 cada entrega tiene **URL permanente propia** desde el primer día:
`/parasha/<slug>-<año>/`. `/parasha/` ya no contiene HTML — es un **redirect 302** a la
entrega vigente, y por eso **no aparece en el sitemap**.

Por qué importa: mientras `/parasha/` sirvió el contenido de la semana, cada parashá
perdía su historial de indexación a los siete días y luego competía consigo misma con
el permalink que se creaba después. Un 302 (no 301) es lo correcto aquí porque el
destino cambia cada semana y un 301 se cachearía en el navegador y en Google.

### El comando

```bash
./nueva-parasha.sh <slug> <año> --nombre "Reé" --titulo "Reé: <subtítulo>"
```

En un solo paso crea el permalink nuevo a partir de la entrega vigente (canonical,
`og:url` y JSON-LD ya apuntando al permalink), marca la saliente como archivada,
mueve el redirect de `/parasha/` en `vercel.json`, añade la ficha y el `ItemList` en
`/parasha/archivo/` y regenera el sitemap.

**No redacta el comentario**: deja marcadores `TODO` y avisa de cuántos quedan. La
página no se publica hasta que estén todos sustituidos.

### El orden, sin saltarse pasos

```bash
./nueva-parasha.sh ree 5786 --nombre "Reé" --titulo "Reé: ..."
grep -n TODO parasha/ree-5786/index.html parasha/archivo/index.html   # redactar
git add -A && git commit -m "content(parasha): archiva Ékev y publica Reé 5786"
git push origin main                       # dispara el deploy en Vercel
# esperar ~1 min a que termine el deploy, y sólo entonces:
curl -sSI https://zoharlatinoamerica.site/parasha/          # 307 → /parasha/ree-5786/
curl -sSI https://zoharlatinoamerica.site/parasha/ree-5786/ # 200
./generar-sitemap.sh --check                                # sin diferencias
./indexnow.sh                                               # Bing / Yandex
```

Y al final, en Search Console: **Inspección de URL** → `https://zoharlatinoamerica.site/parasha/<slug>-<año>/`
→ *Solicitar indexación*. IndexNow no llega a Google; ese paso es manual y no lo cubre
ningún script.

## Contenido nuevo → notificar a Bing

```bash
./indexnow.sh                          # todas las URLs del sitemap
./indexnow.sh /parasha/ekev-5786/      # solo una ruta
```

Ejecútalo tras desplegar la parashá de cada semana. Para Google, el equivalente es
"Solicitar indexación" en Search Console.

## El sitemap no se edita a mano

```bash
./generar-sitemap.sh          # regenera sitemap.xml
./generar-sitemap.sh --check  # falla si quedó desincronizado
```

`lastmod` sale de `git log -1 --format=%cs` sobre cada `index.html`: es la única fecha
que no puede mentir. Un sitemap con fechas inventadas enseña a Google a ignorar los
`lastmod` y a bajar la frecuencia de rastreo — justo lo contrario de lo que necesita un
sitio con entrega semanal.

## Wikipedia — la respuesta honesta

**No se puede forzar y no deberíamos intentarlo.** Wikipedia exige *notabilidad*:
cobertura significativa en fuentes secundarias independientes (prensa, publicaciones
académicas) que ya hayan hablado del proyecto. Además prohíbe explícitamente que el
propio sujeto escriba su artículo — se detecta como conflicto de interés y se borra,
dejando además un antecedente negativo.

El camino real es indirecto y lento: que el trabajo genere cobertura independiente.
Si algún día existe, alguien más lo escribirá. Nada de lo que hagamos en el sitio lo
acelera.

Lo que sí es alcanzable y se parece a lo que buscas: un **Knowledge Panel de Google**,
que no depende de Wikipedia sino de que la entidad sea consistente y verificable —
exactamente lo que construye el `sameAs` del JSON-LD, más Search Console verificado.

## Actualización 19 julio 2026

**`/biblioteca/` ya está indexada** ("La URL está en Google"). En dos días desde que
solicitamos indexación, Google la aceptó. Es una señal buena: el sitio no está
penalizado ni bloqueado — entra. Tras reescribir la biblioteca con contenido propio
se pidió re-indexación para que Google actualice a la versión nueva. El informe
agregado de "Páginas" aún procesa datos (va con retraso de ~1 día).

## Expectativas realistas

- **Indexación**: ya está ocurriendo (biblioteca dentro en 2 días). La home y las otras
  pueden tardar algo más; solicitar indexación pide revisión, no la garantiza, pero el
  hecho de que la biblioteca entrara confirma que el sitio es indexable sin problemas.
- **"Zohar Latinoamérica"** → primer puesto es muy alcanzable: es tu marca.
- **"Zohar", "Cábala en español"** → competencia real y establecida. No hay atajo:
  eso se gana con contenido sostenido (la parashá semanal es la mejor apuesta) y
  con enlaces entrantes genuinos.
- **El video**: 117 vistas en 2 semanas con 1.75 K suscriptores. La descripción ya
  enlaza al sitio, que es correcto. Los enlaces de YouTube son `nofollow` (no pasan
  autoridad de posicionamiento) pero sí traen tráfico real y sirven de vía de descubrimiento.

## Actualización 12 agosto 2026

Se publicaron dos entregas nuevas con URL permanente propia — **Reé 5786**
(`/parasha/ree-5786/`) y **Shoftim 5786** (`/parasha/shoftim-5786/`) — con
el flujo de `nueva-parasha.sh`: redirect 302 de `/parasha/` → Shoftim,
archivo y `ItemList` actualizados, y sitemap regenerado. El sitemap tiene
**9 URLs** y `generar-sitemap.sh --check` está en verde.

Estado de indexación conocido (verificación más reciente): **indexadas** `/`,
`/biblioteca/`, `/parasha/archivo/`; **pendientes** `/ensayo/`, los
permalinks de parashá y las dos entregas nuevas. Google descubre el sitio por
sitemap y canonical sin problemas — lo que falta es solicitud de indexación y
tiempo de rastreo.

### Acciones humanas en Search Console (cuenta `zoharlatinoamerica@`)

Inspección de URL → **Solicitar indexación** para:
- `https://zoharlatinoamerica.site/parasha/ree-5786/` (nuevo)
- `https://zoharlatinoamerica.site/parasha/shoftim-5786/` (nuevo)
- Re-solicitar: `/ensayo/`, `/parasha/devarim-5786/`,
  `/parasha/ekev-5786/`, `/parasha/vaetchanan-5786/`

Y el resto del ritual tras el deploy: `./indexnow.sh` (Bing/Yandex) +
verificación de las URLs con `curl`.

### Sigue pendiente de la auditoría de agosto
- **GA4**: reemplazar `G-XXXXXXXXXX` en `index.html` y descomentar el bloque.
- **DNS en Hostinger**: registro `A calendario → 76.76.21.21` (paso 3.2 de
  `DESPLIEGUE.md`) para activar los subdominios del Gran Ciclo y Zivug.

## Lo que de verdad movería la aguja ahora

El techo ya no es técnico — el andamiaje está puesto. Lo que falta es lo que Google
premia y hoy no encuentra:

1. **Contenido propio y sustancial, publicado con constancia.** La parashá semanal es
   la mejor apuesta: es original, tiene fecha, y nadie más la escribe así en español.
   Una página nueva por semana durante unos meses cambia el perfil del dominio.
2. **La biblioteca no puede ser solo enlaces.** Una página que remite a fuentes externas
   es exactamente lo que Google clasifica como de bajo valor. Cada obra necesita texto
   propio: introducción, contexto, comentario.
3. **Enlaces entrantes reales.** Los de YouTube y Facebook son `nofollow`. Hace falta
   que otros sitios citen el ensayo — foros de estudio, blogs de cabalá, universidades.
   Uno bueno vale más que cien de directorios.
4. **El ensayo es el activo más fuerte**: 14 capítulos originales. Merece ser lo que
   se comparte y se cita, no solo lo que se enlaza desde un video.
