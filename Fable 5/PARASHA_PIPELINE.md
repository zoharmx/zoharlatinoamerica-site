# PARASHA_PIPELINE.md — Motor semanal de la parashá
### El proceso semiautónomo que alimenta sitio, membresía, newsletter y canal

## Cadencia
Cada semana, idealmente **lunes o martes** (la parashá se lee el Shabat
siguiente). Duración total del humano: **~45 min/semana**. Del agente: 1 sesión.

## División del trabajo

### Lo que hace el AGENTE (1 sesión semanal)
1. Consultar la parashá de la semana (Hebcal API, geonameid 3995465) y la
   posición del Gran Ciclo (API propia `/api/calendar/today`).
2. Redactar el paquete de 4 piezas con fuentes citadas (plantilla: carpeta
   `parasha/devarim-5786/` como referencia de estructura y voz):
   - **Página pública** → **primero archivar** la entrega saliente: copiar
     `plataforma/parasha/index.html` a `plataforma/parasha/<parasha>-5786/index.html`
     y ajustar canonical, `og:url`, `@id`/`url`/`mainEntityOfPage` del JSON-LD,
     la banda `.archivo-aviso` y el enlace «Parashá actual» en nav y footer.
     *Después* reescribir `parasha/index.html` con la parashá nueva (título,
     fechas, lectura, comentario ~70%, CTA membresía, `<title>`, metas OG y
     línea de fuentes). Añadir la URL archivada al `sitemap.xml` y la ficha
     nueva a `parasha/archivo/index.html`. Cada entrega conserva su URL
     permanente: `/parasha/` es siempre «la semana actual».
   - **Guía de miembros** (`GUIA_MIEMBROS_<parasha>_<año>.md`): comentario
     íntegro + 5 preguntas de estudio + práctica de la semana + fuentes.
   - **Guion de video** (`GUION_VIDEO_...md`): gancho, 4 bloques, cierre con
     CTA, título A/B, miniatura, descripción y comentario fijado.
   - **Newsletter** (`NEWSLETTER_...md`): asunto + cuerpo corto con enlaces.
3. Commit + push a `main` (deploy automático) + verificación con curl.
4. Registrar la entrega en EXPERIMENT_LOG.md.

### Lo que hace el HUMANO (~45 min — checkpoint editorial OBLIGATORIO)
1. **Revisar la doctrina y las fuentes** de la página pública y la guía
   (10–15 min). Regla de la casa: ninguna cita inventada; ante la duda,
   generalizar la referencia o quitarla.
2. **Producir el video** con el guion (o grabar solo la voz). Si usa voz/
   imágenes sintéticas: marcar "contenido alterado o sintético" al subir.
3. **Publicar el video** jueves o viernes AM + pegar descripción y comentario
   fijado del guion.
4. **Enviar la newsletter** (hoy: Gmail manual a la lista de FormSubmit;
   migrar a Brevo/MailerLite cuando la lista pase de ~50 correos).
5. **Enviar la guía a los miembros** (correo a la lista de suscriptores de
   Stripe: Dashboard → Clientes → filtrar suscripción activa).

## Reglas editoriales fijas
- Toda afirmación con fuente: Tanaj (libro cap:vers), Rashi/Sifrei/Midrash,
  Zohar (sección; folio solo si está verificado), Talmud (tratado y folio).
- La reprensión/corrección siempre en la voz de la casa: sin polémica, sin
  política partidista, sin promesas materiales.
- El contenido público es ~70% del valor; la guía de miembros agrega
  preguntas, práctica y la capa del Gran Ciclo desarrollada.
- Declarar contenido sintético en YouTube cuando aplique (política de
  contenido inauténtico, jul-2025).

## Calendario de las entregas (5786)
| Shabat | Parashá | Nota |
|---|---|---|
| 18 jul 2026 | **Devarim** ✅ | Shabat Jazón — archivada en `/parasha/devarim-5786/` con video |
| 25 jul 2026 | **Vaetjanán** ✅ | Shabat Najamú — archivada en `/parasha/vaetchanan-5786/` con video |
| 1 ago 2026 | **Ékev** ✅ | 18 de Av — archivada en `/parasha/ekev-5786/`; video pendiente del humano |
| 8 ago 2026 | **Reé** ✅ | 25 de Av — entregada el 12 ago (4 días tarde) en `/parasha/ree-5786/`; video pendiente |
| 15 ago 2026 | **Shoftim** ✅ | 2 de Elul — entregada el 12 ago en `/parasha/shoftim-5786/`; arranca la serie de teshuvá; video pendiente |
| 22 ago 2026 | **Ki Teitzei** ✅ | 9 de Elul — entregada el 20 ago (2 días antes) en `/parasha/ki-teitzei-5786/`; video pendiente |
| 29 ago 2026 | **Ki Tavó** ✅ | 16 de Elul — entregada el 28 ago (víspera del Shabat) en `/parasha/ki-tavo-5786/`; Devarim 26:1–29:8 · Haftará Yeshayahu 60:1–22 (sexta de consuelo); video pendiente |
| 5 sep 2026 | **Nitzavim-Vayeilej** | 23 de Elul — Devarim 29:9–31:30 · Haftará Yeshayahu 61:10–63:9 (séptima de consuelo) |
| 12 sep 2026 | **Rosh Hashaná 5787** | 1 de Tishrei — cierre del año; la entrega de Nitzavim-Vayeilej es la última del ciclo 5786 |

> **Lección de Reé (atrasada):** publicar **antes** del Shabat de la lectura.
> Si una entrega se atrasa, publicarla igual en cuanto se pueda — `datePublished`
> lleva la fecha real de publicación, la meta-linea lleva la fecha de la lectura,
> y el permalink del archivo no pierde la posición.

## Métricas que importan (revisar en Fase 5)
- Visitas a /parasha/ (Vercel Analytics)
- Clics al Payment Link de membresía (Stripe → Payment Links → métricas)
- Nuevos miembros activos (Stripe → Suscripciones)
- Suscripciones al boletín (correos de FormSubmit)
- Retención del video semanal (YouTube Studio)
