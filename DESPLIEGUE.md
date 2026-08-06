# Despliegue de zoharlatinoamerica.site

## ✅ Estado actual (2 de julio de 2026)

- **Desplegado en producción**: https://zoharlatinoamerica-site.vercel.app
- **Repositorio**: https://github.com/zoharmx/zoharlatinoamerica-site (push a `main` = deploy automático)
- **Dominios agregados al proyecto Vercel**: `zoharlatinoamerica.site` y `www.zoharlatinoamerica.site`
  — pendientes SOLO del cambio de DNS en Hostinger (ver abajo).

### Único paso manual pendiente: DNS en Hostinger

1. Entra a **hpanel.hostinger.com** → Dominios → `zoharlatinoamerica.site` → **DNS / Nameservers**.
2. En la zona DNS, edita/crea estos dos registros:
   - Tipo `A` · Nombre `@` · Valor `76.76.21.21` (borra el registro A actual que apunta al builder)
   - Tipo `CNAME` · Nombre `www` · Valor `cname.vercel-dns.com`
3. Guarda. La propagación tarda de minutos a unas horas; Vercel verifica solo y emite el SSL.

⚠️ Esto reemplaza la web actual del builder de Hostinger por la nueva plataforma (es el objetivo).
El correo no se afecta (no hay registros MX personalizados que tocar; si Hostinger te muestra
registros MX, NO los borres).


La plataforma está en esta carpeta (`plataforma/`) como sitio estático listo para Vercel.
No requiere build: es HTML puro, carga instantánea, SEO completo.

## Estructura

```
plataforma/
├── index.html            → Portal principal (https://zoharlatinoamerica.site/)
├── ensayo/index.html     → Sefarad como Pardés Invertido (/ensayo/)
├── biblioteca/index.html → Biblioteca cabalística (/biblioteca/)
├── vercel.json           → Redirects (/calendario, /zivug, /youtube…) + headers
├── robots.txt / sitemap.xml
└── DESPLIEGUE.md / IDEAS.md
```

## Paso 1 — Desplegar en Vercel (5 minutos)

```bash
cd "C:\Users\diosd\zivug\Zivug\zoharlatinoamerica.site\plataforma"
npx vercel --prod
```

(O crea un proyecto nuevo en vercel.com y arrastra la carpeta `plataforma`.)

## Paso 2 — Conectar el dominio

1. En Vercel → proyecto → **Settings → Domains** → añade `zoharlatinoamerica.site` y `www.zoharlatinoamerica.site`.
2. En tu registrador de dominio, configura los DNS que Vercel te indique:
   - `A` @ → `76.76.21.21`
   - `CNAME` www → `cname.vercel-dns.com`
3. Espera la propagación (minutos a horas). SSL es automático.

## Paso 3 — Un solo dominio para todo (subdominios)

**Estado: pendiente de ejecutar.** Se contempló en julio de 2026 y nunca se hizo. Es la
tarea con más valor SEO sin hacer del proyecto: hoy `/calendario` y `/zivug` son
redirects 307 hacia `*.vercel.app`, así que el Gran Ciclo Hebreo y Zivug — los dos
activos que nadie más tiene en español — acumulan toda su autoridad en dominios que no
son la marca. Un redirect 307 no transfiere autoridad: la deja en el destino.

| App | Proyecto Vercel | Host actual | Subdominio destino |
|---|---|---|---|
| Portal (esta carpeta) | `zoharlatinoamerica-site` | `zoharlatinoamerica.site` | — |
| Gran Ciclo Hebreo | `calendar-app-eight-eta` | `calendar-app-eight-eta.vercel.app` | `calendario.zoharlatinoamerica.site` |
| Zivug (`/mazal`) | `calendar-app-eight-eta` | `calendar-app-eight-eta.vercel.app/mazal` | `calendario.zoharlatinoamerica.site/mazal` |

> Zivug **no** vive en `frontend-beige-phi-95.vercel.app`. Ese deploy sirve hoy otra
> cosa (*Tikun Olam — Ethical AI Reasoning*). Zivug es la ruta `/mazal` dentro del
> proyecto del calendario, que es a donde ya apunta el redirect de `vercel.json`.
> Comprobado el 5 de agosto de 2026. Ver la nota al final de esta sección.

### 3.1 — En el panel de Vercel (proyecto `calendar-app-eight-eta`)

Settings → Domains → **Add** → `calendario.zoharlatinoamerica.site` → *Add*.
Vercel mostrará el registro DNS que espera y quedará en estado *Invalid Configuration*
hasta que el DNS propague. Es normal.

### 3.2 — En Hostinger (hpanel.hostinger.com → Dominios → zoharlatinoamerica.site → DNS)

Crear **un** registro nuevo. No tocar ni borrar nada de lo existente (en particular,
no tocar el registro `A @` que apunta a `76.76.21.21` ni ningún MX):

| Tipo | Nombre | Valor | TTL |
|---|---|---|---|
| `CNAME` | `calendario` | `cname.vercel-dns.com` | 3600 (o el que ofrezca por defecto) |

Si más adelante Zivug se separa a su propio proyecto de Vercel, entonces — y sólo
entonces — añadir además:

| Tipo | Nombre | Valor | TTL |
|---|---|---|---|
| `CNAME` | `zivug` | `cname.vercel-dns.com` | 3600 |

### 3.3 — Comprobar antes de cambiar nada en el código

```bash
curl -sSI https://calendario.zoharlatinoamerica.site/       # debe dar 200
curl -sSI https://calendario.zoharlatinoamerica.site/mazal  # debe dar 200
```

**Mientras estas dos comprobaciones no den 200, no toques `vercel.json`**: activar los
redirects antes de tiempo rompe dos enlaces que hoy funcionan.

### 3.4 — Activar los redirects

Los redirects ya están escritos y listos para copiar en
[`vercel.subdominios.json.ejemplo`](vercel.subdominios.json.ejemplo). `vercel.json` es
JSON estricto y no admite comentarios, por eso viven en un archivo aparte que Vercel
ignora. Sustituye en `vercel.json` los cuatro redirects de `/calendario` y `/zivug` por
los de ese archivo, y actualiza también los enlaces visibles en `index.html` y
`biblioteca/index.html` (busca `calendar-app-eight-eta`).

Cuando los subdominios lleven semanas estables, esos redirects pueden pasar de 307 a
301 (`"permanent": true`) para que transfieran autoridad. No antes: un 301 se cachea.

### 3.5 — Después de activar

- Search Console: añadir `calendario.zoharlatinoamerica.site` como propiedad y enviar
  su sitemap, si el proyecto del calendario lo tiene.
- Revisar que `calendar-app-eight-eta.vercel.app` deje de indexarse: en su repo, el
  mismo `X-Robots-Tag: noindex, nofollow` condicionado a ese host que este repo ya
  aplica a `zoharlatinoamerica-site.vercel.app`.

Mientras tanto, `/calendario` y `/zivug` siguen redirigiendo a las URLs actuales de
Vercel, así que `zoharlatinoamerica.site/calendario` se puede compartir desde hoy.

## El video

`Latinoamerica.mp4` (388 MB) **no se sube al hosting**: es el mismo contenido que ya
está en YouTube (https://youtu.be/pfRQjh97G7o) y de ahí viene el tráfico. El portal lo
embebe con `youtube-nocookie.com`, lo que además cuenta las vistas en tu canal y
alimenta el algoritmo. Subirlo aparte dividiría las métricas y excede los límites de
Vercel.

## Registro de visitantes (analítica)

Recomendación en dos capas:

1. **Vercel Web Analytics** (activar ya): dashboard del proyecto → Analytics → Enable,
   y descomenta la línea `/_vercel/insights/script.js` al final de `index.html`.
   Sin cookies, sin banner de consentimiento, cumple GDPR.
2. **Google Analytics 4** (cuando quieras profundidad): mide de qué video/red viene
   cada visitante (tráfico de YouTube y Facebook aparece como referral), embudos y
   conversiones. Crea la propiedad en analytics.google.com, copia el ID `G-…` y
   descomenta el bloque GA4 al final de `index.html` (está listo, solo falta el ID).
3. *(Opcional, privacidad máxima)* **Umami** autoalojado en tu VPS Ubuntu — datos 100%
   tuyos, panel propio. Buena opción v2 si prefieres no depender de Google.

**Consejo clave para atribución**: en la descripción del video de YouTube y en los
posts de Facebook usa enlaces con UTM, p. ej.
`https://zoharlatinoamerica.site/?utm_source=youtube&utm_medium=video&utm_campaign=pelicula_zohar`
Así GA4/Vercel te dirán exactamente cuántos llegaron desde la película.

## Verificación local

Abre `index.html` directamente en el navegador, o sirve la carpeta:

```bash
npx serve "C:\Users\diosd\zivug\Zivug\zoharlatinoamerica.site\plataforma"
```
