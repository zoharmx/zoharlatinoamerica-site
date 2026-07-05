# Documento técnico — Zohar Latinoamérica (portal)

**Última actualización:** 4 de julio de 2026

## 1. Propósito y contexto

Este portal existe para capitalizar el tráfico de un video de YouTube (*El Secreto del Sagrado Libro del Zohar*) con distribución activa del algoritmo, y convertir ese tráfico efímero en tres activos permanentes: lista de email, comunidad (WhatsApp/newsletter) y acceso a las dos herramientas diferenciadoras del ecosistema — el **Gran Ciclo Hebreo** (calendario de 6.004 años) y **Zivug** (carta natal hebrea).

No es una aplicación — es un portal de captación estático que orquesta enlaces hacia aplicaciones que viven en otros repos y otros deploys de Vercel.

## 2. Arquitectura

```
                    ┌─────────────────────────────┐
                    │  zoharlatinoamerica.site      │
                    │  (este repo — HTML estático)  │
                    │  Vercel: zoharlatinoamerica-  │
                    │  site                         │
                    └───────────┬───────────────────┘
                                │ redirects (vercel.json)
              ┌─────────────────┼─────────────────┐
              │                 │                 │
              ▼                 ▼                 ▼
     /calendario           /zivug            (embebido)
     redirect 307          redirect 307       YouTube iframe
              │                 │             youtube-nocookie.com
              ▼                 ▼
  calendar-app-eight-eta   frontend-beige-phi-95
  .vercel.app              .vercel.app
  ─────────────────────    ─────────────────────
  Next.js 14                Vite + React
  Proxy API → backend        Vercel project: frontend
  FastAPI (calendario        (repo zoharmx/zivug)
  hebreo, SQLite 2.19M
  filas)
```

**Tres repos de GitHub distintos, tres proyectos de Vercel distintos, un solo dominio público.** La unión ocurre únicamente a nivel de `redirects` en `vercel.json` — no hay compartición de código, estado, ni sesión entre las tres piezas.

## 3. Stack

| Capa | Tecnología | Por qué |
|---|---|---|
| Portal | HTML5 + CSS puro (sin framework, sin build step) | Cero fricción de deploy, cero dependencias que rompan, carga instantánea para tráfico de video viral |
| Tipografía | Google Fonts (EB Garamond, Cinzel, Source Sans 3) | Única dependencia externa de render — carga vía `@import`, sin bloqueo crítico |
| Hosting | Vercel (proyecto `zoharlatinoamerica-site`) | Deploy automático por push a `main`, CDN global, SSL automático |
| DNS | Hostinger → registros `A`/`CNAME` apuntando a Vercel | Dominio comprado en Hostinger, hosting en Vercel — separación estándar dominio/hosting |
| Captura de leads | FormSubmit (`formsubmit.co`) | Sin backend propio; POST directo a un servicio de terceros que reenvía por email |
| Analítica | Vercel Web Analytics (activo) + GA4 (preparado, sin ID) | Doble capa: una sin cookies/consentimiento (Vercel), otra con atribución de campaña por UTM (GA4) |
| Video | Embed `youtube-nocookie.com`, no hosting propio | El archivo fuente (388MB) excede lo razonable para CDN estático; además el embed cuenta como vista del canal, alimentando el algoritmo que genera el tráfico |

## 4. Relación con el resto del ecosistema Zivug

Este portal es la **capa de distribución** de un ecosistema más grande documentado en `CLAUDE.md` (raíz del proyecto `C:\Users\diosd\zivug\Zivug`):

- **Gran Ciclo Hebreo** — el activo de datos más diferenciado del proyecto (base SQLite de 2.192.942 filas, años AM 1–6004). El portal no contiene ninguna lógica del calendario; solo enlaza (`/calendario`) al deploy independiente en `calendar-app-eight-eta.vercel.app`.
- **Zivug** — el motor de alineación personal de 10 dimensiones (mapeo Sefirot). El portal enlaza (`/zivug`) al deploy en `frontend-beige-phi-95.vercel.app`, que a su vez vive en el repo `zoharmx/zivug` (confusingly distinto del repo de este portal).
- **Biblioteca cabalística** — no reimplementa ninguna fuente; es un índice curado hacia Sefaria y otras fuentes públicas en español. Decisión deliberada para evitar problemas de copyright con traducciones existentes del Zohar.

**Implicación operativa:** un cambio en el backend del calendario o en el frontend de Zivug (ver `HANDOFF.md` del proyecto raíz para el estado más reciente de esos deploys) **no requiere ningún cambio en este repo**, salvo que cambie la URL de destino — en cuyo caso se actualiza únicamente `vercel.json` → `redirects`.

## 5. Decisiones de diseño relevantes

- **`cleanUrls: true` y `trailingSlash: true`** en `vercel.json` — URLs limpias (`/ensayo/` en vez de `/ensayo/index.html`), mejor para SEO y para compartir en redes.
- **Redirects temporales (307) vs permanentes (301)** — `/calendario` y `/zivug` son `permanent: false` (307) a propósito: apuntan a URLs de Vercel que van a cambiar cuando se complete la unificación de subdominios (ver `DESPLIEGUE.md`), y un 301 cachearía el destino viejo en navegadores/buscadores.
- **Sin gestor de contenido ni CMS** — todo el contenido (ensayo, biblioteca) es HTML escrito a mano. Correcto para el volumen actual; si la biblioteca crece más allá de un índice curado (ver sección "Zohar en español propio" en `IDEAS.md`), este es el primer punto donde valdría la pena introducir un generador estático (Astro/Eleventy) sin perder el enfoque cero-build para el portal principal.
- **Sin backend propio** — la única "escritura" que ocurre es el formulario de email, delegado por completo a FormSubmit. No hay base de datos, no hay autenticación, no hay superficie de ataque más allá de servir archivos estáticos.

## 6. Seguridad

- Headers ya configurados en `vercel.json`: `X-Content-Type-Options: nosniff`, `X-Frame-Options: SAMEORIGIN`, `Referrer-Policy: strict-origin-when-cross-origin`.
- No hay secretos, tokens ni API keys en este repositorio.
- Sugerido (no implementado): `Content-Security-Policy` explícito. Las únicas fuentes externas activas son Google Fonts, `youtube-nocookie.com`, `formsubmit.co` y `/_vercel/insights/`, lo que hace una política restrictiva viable sin fricción.

## 7. Puntos de fragilidad conocidos

1. **Dependencia de 3 dominios `.vercel.app` distintos** para las herramientas — si Vercel cambia el hash de deploy o el proyecto se relinkea, los redirects en `vercel.json` quedan apuntando a una URL muerta silenciosamente (esto ya pasó una vez con un error de Firebase en el proyecto `frontend`, corregido el 4 de julio de 2026 — ver `HANDOFF.md` raíz).
2. **Sin monitoreo cruzado** — al ser 3 proyectos de Vercel separados, un error en uno no es visible desde la analítica de los otros dos.
3. **GA4 a medias** — el snippet existe pero el ID (`G-XXXXXXXXXX`) nunca se reemplazó, así que no está recolectando datos reales pese a estar "presente" en el HTML.

## 8. Cómo extender esto

- **Nueva sección de contenido** (ej. artículos): seguir el patrón de `/ensayo/` — carpeta propia con su `index.html`, enlazada desde `index.html` y añadida a `sitemap.xml`.
- **Nueva herramienta externa**: agregar un `redirect` en `vercel.json`, no construir la integración aquí.
- **Cambiar de redirect a subdominio real** (recomendado, ver `DESPLIEGUE.md` sección "Un solo dominio para todo"): agregar el subdominio en el proyecto Vercel de destino, apuntar el DNS, y solo entonces cambiar el `redirect` por el subdominio final en `vercel.json`.
