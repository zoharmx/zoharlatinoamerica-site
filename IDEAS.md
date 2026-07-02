# Ideas, sugerencias y lo que necesito de ti

## Lo que ya está construido

- **Portal** (`index.html`) — hero con identidad visual del ensayo, película embebida
  de YouTube, ensayo destacado con índice de los 14 capítulos, herramientas
  (Calendario, Zivug, Biblioteca), sección Escuela con botones de suscripción.
- **Ensayo completo** (`/ensayo/`) — con barra de regreso al portal y botones al final
  (volver / ver la película).
- **Biblioteca** (`/biblioteca/`) — parashiot del Zohar por libro enlazadas a Sefaria,
  Tanaj, Talmud, Midrash, obras cabalísticas y fuentes en español.
- **SEO** — meta OG (la miniatura de la película como imagen social), sitemap, robots.
- **Redirects cortos** — `/calendario`, `/zivug`, `/youtube`, `/facebook`, `/pelicula`.

## Prioridad #1 (mi consejo más importante)

El 97% de tu tráfico viene de UN video que YouTube está distribuyendo AHORA.
Esa ventana no dura para siempre. Lo urgente no es más software, es **capturar esa
audiencia**:

1. **Despliega hoy** (ver DESPLIEGUE.md) y pon el enlace `zoharlatinoamerica.site`
   como primera línea de la descripción del video, en un comentario fijado y en una
   tarjeta/pantalla final del video.
2. **Captura de emails** — es la única audiencia que YouTube no te puede quitar.
   Recomiendo empezar simple: un formulario (Brevo o MailerLite, gratis hasta
   ~1.000–2.000 contactos) ofreciendo algo a cambio: *"Recibe el ensayo en PDF +
   la parashá comentada cada semana"*. Puedo integrarlo al portal en cuanto elijas
   proveedor.
3. **Segundo video** — el ensayo Sefarad como Pardés Invertido es material para otra
   película. El algoritmo ya sabe que tu audiencia existe.

## Ideas para la plataforma (ordenadas por impacto/esfuerzo)

### Corto plazo
- **PDF del ensayo** como lead magnet (lo genero desde el HTML cuando quieras).
- **Parashá de la semana en el portal** — módulo que muestra la parashá actual con tu
  comentario y enlace al Zohar correspondiente. Conecta biblioteca + calendario + escuela.
- **"Hoy en el calendario hebreo"** — widget en el portal: fecha hebrea de hoy, fase
  lunar, posición metónica, sacado de tu base de datos de 2.19M días. Nadie más tiene esto.
- **WhatsApp/Telegram de la escuela** — botón en la sección comunidad; los canales de
  difusión convierten mejor que el email en Latinoamérica.

### Mediano plazo
- **Sección Artículos** — el ensayo es el primero; la estructura ya lo permite
  (`/articulos/nombre/`). Cada video nuevo debería tener su artículo fuente aquí (SEO
  + hábito de audiencia).
- **Zohar en español propio** — las traducciones existentes tienen copyright, pero tu
  propia traducción/comentario parashá por parashá sería EL activo diferenciador en
  español. Publicable semanalmente = contenido perpetuo + newsletter + video.
- **Carta natal hebrea completa** — unir Zivug + calendario: ingresas fecha de
  nacimiento y recibes fecha hebrea, parashá de nacimiento, posición metónica, fase
  lunar y análisis. Los datos ya existen en la DB; falta la interfaz unificada.
- **Cursos** — la escuela como producto: curso introductorio gratuito (email requerido)
  y cursos de pago. Hotmart/Gumroad para Latinoamérica.

### Largo plazo
- **Membresía** — comunidad de estudio con acceso a materiales, sesiones en vivo.
- **App del Gran Ciclo** — el calendario como PWA instalable con notificaciones de
  festividades y Shabat.
- **API pública del Gran Ciclo** — ya tienes el análisis go-to-market en el repo.

## Lo que necesito de ti

1. **Acceso al dominio** — ¿dónde está registrado `zoharlatinoamerica.site`? Necesitas
   poder editar sus DNS (tú lo haces siguiendo DESPLIEGUE.md, o me dices el registrador
   y te doy los pasos exactos).
2. **Cuenta de Vercel** — ¿ya tienes una (las apps calendar y zivug están en Vercel)?
   El portal debe desplegarse ahí mismo para unificar dominios.
3. **Decisión de analítica** — ¿GA4, Vercel Analytics, o ambos? (Recomiendo ambos;
   los snippets ya están preparados en `index.html`.)
4. **Proveedor de email** — Brevo, MailerLite u otro, para el formulario de captura.
5. **Textos en español** — ¿tienes traducciones propias del Zohar o materiales de la
   escuela que podamos publicar en la biblioteca? Eso es lo que la convertiría de
   índice de enlaces a biblioteca real.
6. **Logo/branding** — si existe logo del canal en buena resolución, lo integro al
   portal (ahora usa tipografía Cinzel como marca).
7. **WhatsApp/Telegram** — si tienes canal o grupo de la escuela, pásame el enlace.
