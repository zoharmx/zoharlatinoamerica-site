# SEO — que "Zohar Latinoamérica" te encuentre

## El diagnóstico (17 julio 2026)

El sitio está vivo y bien construido, pero **Google no lo tiene indexado**:
`site:zoharlatinoamerica.site` devuelve cero resultados. No es que posicione mal —
es que Google no sabe que existe. El dominio es nuevo y no tiene enlaces entrantes
que lo hagan descubrible.

Buscar "Zohar Latinoamérica" hoy devuelve kabbalah.info, Kabbalah Centre y Amazon.
Ninguno de ellos compite por ese nombre exacto: es tu marca. Una vez indexado, esa
consulta es muy ganable. "Zohar" a secas es otra historia — ahí hay competidores con
años de autoridad y no existe atajo técnico.

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

## Pendiente — requiere tu login

### 1. Google Search Console (lo que de verdad destraba Google)

1. Entra a https://search.google.com/search-console con **zoharlatinoamerica@gmail.com**.
2. Añadir propiedad → elige **Dominio** e introduce `zoharlatinoamerica.site`.
   (Dominio es mejor que "Prefijo de URL": cubre `www`, `http`/`https` y los futuros
   subdominios `calendario.` y `zivug.` de una sola vez.)
3. Google te dará un registro **TXT**. Cópialo.
4. Ve a **hpanel.hostinger.com** → Dominios → `zoharlatinoamerica.site` → DNS.
   Añade: Tipo `TXT` · Nombre `@` · Valor `google-site-verification=...`
5. Vuelve a Search Console → **Verificar**. (Si falla, espera y reintenta: el DNS
   tarda de minutos a unas horas.)
6. Ya dentro: **Sitemaps** → añade `sitemap.xml` → Enviar.
7. **Inspección de URLs** → pega `https://zoharlatinoamerica.site/` → **Solicitar indexación**.
   Repite para `/ensayo/`, `/biblioteca/` y `/parasha/`.

> Si prefieres no tocar el DNS: elige "Prefijo de URL" con `https://zoharlatinoamerica.site/`,
> método **etiqueta HTML**, y pega aquí el meta tag que te dé — se añade a `index.html`
> y se despliega. Funciona igual pero no cubre subdominios.

### 2. Bing Webmaster Tools (opcional)

IndexNow ya está notificando a Bing, así que esto es para ver informes, no para indexar.
https://www.bing.com/webmasters → importar directamente desde Search Console.

### 3. Google Analytics 4

`index.html` tiene el bloque GA4 comentado con el placeholder `G-XXXXXXXXXX`.
Crea la propiedad en analytics.google.com, sustituye el ID y descomenta.
Vercel Web Analytics ya está activo y no necesita nada.

## Contenido nuevo → notificar a Bing

```bash
./indexnow.sh              # todas las URLs del sitemap
./indexnow.sh /parasha/    # solo una ruta
```

Ejecútalo tras desplegar la parashá de cada semana. Para Google, el equivalente es
"Solicitar indexación" en Search Console.

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

## Expectativas realistas

- **Indexación**: días o semanas tras Search Console. Sin él, indefinido.
- **"Zohar Latinoamérica"** → primer puesto es muy alcanzable: es tu marca.
- **"Zohar", "Cábala en español"** → competencia real y establecida. No hay atajo:
  eso se gana con contenido sostenido (la parashá semanal es la mejor apuesta) y
  con enlaces entrantes genuinos.
- **El video**: 117 vistas en 2 semanas con 1.75 K suscriptores. La descripción ya
  enlaza al sitio, que es correcto. Los enlaces de YouTube son `nofollow` (no pasan
  autoridad de posicionamiento) pero sí traen tráfico real y sirven de vía de descubrimiento.
