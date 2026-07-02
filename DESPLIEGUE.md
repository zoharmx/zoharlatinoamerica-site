# Despliegue de zoharlatinoamerica.site

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

Las apps ya desplegadas se integran bajo el mismo dominio:

| App | Proyecto Vercel actual | Dominio final sugerido |
|---|---|---|
| Portal (esta carpeta) | nuevo | `zoharlatinoamerica.site` |
| Gran Ciclo Hebreo | calendar-app-eight-eta | `calendario.zoharlatinoamerica.site` |
| Zivug | frontend-beige-phi-95 | `zivug.zoharlatinoamerica.site` |

Para cada una: en su proyecto de Vercel → Domains → añade el subdominio, y en el DNS
añade `CNAME calendario → cname.vercel-dns.com` (igual para `zivug`).

Cuando los subdominios estén activos, actualiza los enlaces en `index.html`,
`biblioteca/index.html` y `vercel.json` (busca `calendar-app-eight-eta` y
`frontend-beige-phi-95` y reemplaza por los subdominios).

Mientras tanto, `/calendario` y `/zivug` ya redirigen a las URLs actuales de Vercel
(configurado en `vercel.json`), así que puedes compartir
`zoharlatinoamerica.site/calendario` desde hoy.

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
