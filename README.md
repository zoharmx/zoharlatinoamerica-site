# Zohar Latinoamérica — Portal

Sitio estático (HTML puro, sin build) que unifica el ensayo *Sefarad como Pardés Invertido*, el Gran Ciclo Hebreo, la herramienta Zivug y una biblioteca cabalística curada, bajo el dominio `zoharlatinoamerica.site`.

**Producción:** https://zoharlatinoamerica.site
**Repositorio:** https://github.com/zoharmx/zoharlatinoamerica-site (push a `main` → deploy automático en Vercel)

## Qué es esto

Un portal de captación construido alrededor de un video de YouTube con tráfico viral (*El Secreto del Sagrado Libro del Zohar*). Conecta cuatro piezas que antes vivían dispersas:

| Sección | Ruta | Qué hace |
|---|---|---|
| Portal | `/` | Hero, película embebida, índice del ensayo, acceso a las herramientas, captura de email |
| Ensayo | `/ensayo/` | *Sefarad como Pardés Invertido* completo, 14 capítulos |
| Biblioteca | `/biblioteca/` | Índice curado de parashiot del Zohar, Tanaj, Talmud y Midrash — enlaza a Sefaria, no aloja contenido con copyright |
| Gran Ciclo Hebreo | `/calendario` (redirect) | Calendario interactivo de 6.004 años — proyecto Vercel separado (`calendar-app-eight-eta`) |
| Zivug | `/zivug` (redirect) | Carta personal hebrea — proyecto Vercel separado (`frontend-beige-phi-95`) |

## Por qué no tiene build

El tráfico llega en ráfagas desde un video que YouTube distribuye activamente — la prioridad al desplegar esto fue velocidad de publicación y cero puntos de falla, no una arquitectura de frontend. HTML/CSS/JS plano cumple ese objetivo: no hay `npm install` que pueda romperse, no hay framework que actualizar, carga instantánea.

## Estructura

```
plataforma/
├── index.html            → Portal principal
├── ensayo/index.html     → Ensayo completo
├── biblioteca/index.html → Biblioteca cabalística
├── assets/                → logo.png, logo-jai.png
├── vercel.json            → Redirects + security headers
├── robots.txt / sitemap.xml
├── IDEAS.md                → Estrategia de crecimiento y roadmap (léelo antes de agregar features)
├── DESPLIEGUE.md           → Guía paso a paso de DNS/dominio/analítica
└── DOCUMENTO_TECNICO.md    → Arquitectura, integración con el resto del ecosistema Zivug
```

## Desarrollo local

No requiere instalación. Sirve la carpeta con cualquier servidor estático:

```bash
npx serve .
```

O abre `index.html` directamente en el navegador — no hay rutas relativas que dependan de un servidor.

## Deploy

```bash
npx vercel --prod
```

Push a `main` en GitHub también dispara el deploy automático (integración Git ya conectada). Ver `DESPLIEGUE.md` para la configuración de DNS y dominios si el proyecto se reconecta desde cero.

## Analítica

- **Vercel Web Analytics** — activo (`/_vercel/insights/script.js` en `index.html`).
- **GA4** — snippet preparado en `index.html` pero **pendiente**: reemplaza `G-XXXXXXXXXX` con el ID real o elimina el bloque comentado.
- **Captura de email** — formulario vía FormSubmit (`formsubmit.co`), sin backend propio.

## Integraciones externas (no viven en este repo)

- **Gran Ciclo Hebreo** (calendario) — Next.js, repo `calendar-app`, backend FastAPI + SQLite de 2.19M días. Ver `CLAUDE.md` en la raíz del proyecto Zivug.
- **Zivug** (carta personal) — Vite/React, repo `zoharmx/zivug`, deployado como proyecto Vercel `frontend`.

Ambas están enlazadas por redirect (`/calendario`, `/zivug` en `vercel.json`), no por subdominio, mientras se completa la unificación de dominio descrita en `DESPLIEGUE.md`.

## Notas de seguridad

- `vercel.json` ya define `X-Content-Type-Options`, `X-Frame-Options` y `Referrer-Policy`.
- No hay secretos ni API keys en este repo — es contenido estático puro.
- El video fuente (`Latinoamerica.mp4`, 388MB) vive en `zoharlatinoamerica.site/` (un nivel arriba de `plataforma/`) solo como archivo de referencia local — **no se despliega**, el portal usa el embed de YouTube.
