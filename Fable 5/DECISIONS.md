# DECISIONS.md — Registro de decisiones



### Qué existe y funciona (verificado)

| Activo | Estado | Evidencia |
|---|---|---|
| **zoharlatinoamerica.site** (portal estático: ensayo 14 caps + biblioteca + captura email) | ✅ VIVO en dominio propio (Vercel, deploy automático desde GitHub `zoharmx/zoharlatinoamerica-site`) | WebFetch OK 2026-07-15 |
| **calendar-app** (Next.js): calendario Gran Ciclo + carta natal /mazal + /zivug + /metodologia | ✅ VIVO en `calendar-app-eight-eta.vercel.app`; 4 suites de tests verdes (golden/zivug/tz/coherence) | WebFetch OK; HANDOFF 2026-07-07 |
| **Base de datos Gran Ciclo Hebreo** — 2.19M filas, AM 1–6004, 446 MB | ✅ Existe; activo único en su escala | `gran_ciclo_hebreo.db` local + backend |
| **API comercial v1** (`/v1/gran-ciclo/*` con X-API-Key y rate limit) | ⚙️ Implementada; sin clientes aún | `GRAN_CICLO_API_GO_TO_MARKET.md` con pricing $29/$99/$299 |
| **Canal YouTube** @zoharlatinoamerica + video viral ("El Secreto del Sagrado Libro del Zohar") + Facebook + WhatsApp | ✅ Existe; según IDEAS.md el 97% del tráfico del sitio viene de ese video. Stats no verificables por scraping | tarea.txt, IDEAS.md |
| Backend FastAPI del calendario | ✅ Corre en VPS propio del operador (Ubuntu 24.04) | HANDOFF §documentación |

### Veredicto: SÍ es el punto de partida correcto — supera a empezar de cero

El candidato A aprobado en D-002 (canal parashá/Zohar) **ya tiene aquí su
infraestructura completa**: canal con tráfico real, dominio en producción,
herramientas únicas (calendario 6004 años, carta natal), biblioteca, captura de
emails y hasta un plan B2B redactado (API). Lo ÚNICO que falta es exactamente lo
que este experimento debe construir: **la capa de monetización y el motor de
contenido semanal (parashá) que la alimente**.

### Deudas detectadas que el experimento debe atender (honestidad)

1. **Cero monetización visible** en el sitio hoy (ni donaciones, ni productos, ni membresía).
2. **Seguridad**: HANDOFF ordena rotar claves API expuestas (Anthropic, Gemini,
   DeepSeek, Mistral de `cosmogonologia (2)`); hay archivos `.env` con secretos
   en la raíz del repo. Debe resolverse antes de escalar.
3. **GA4 sin configurar** (placeholder `G-XXXXXXXXXX`) y captura de email vía
   FormSubmit → no construye lista real; migrar a Brevo/MailerLite.
4. **Backend en VPS personal** = punto único de falla; migración a Cloud Run es
   cambio de una línea (`BACKEND_URL`), recomendada cuando haya clientes de pago.
5. Limpieza git pendiente (repos embebidos arrastrados en commit `005dcf3`).

### Fase 1 redefinida (propuesta)

Sobre el ecosistema existente: (a) capa de monetización en el portal — donaciones
+ guía de estudio de la parashá semanal como producto descargable + escuela;
(b) motor semiautónomo de la parashá semanal (módulo web + newsletter + guion de
video para el canal); (c) activar analítica y lista de correo real; (d) beta de
la API Gran Ciclo como línea B2B secundaria (el go-to-market ya existe).

---

## D-005 · Modelo de financiamiento: ¿patrocinios/fundaciones vs suscripciones+tzedaká? — 2026-07-15

Pregunta del operador: ¿es viable buscar patrocinadores, inversión o apoyo de
comunidades/organizaciones/fundaciones para ofrecer todo gratis y vivir solo de
donaciones? ¿O continuar con suscripciones + tzedaká?

### Análisis
**Financiamiento institucional (fundaciones judías educativas, patrocinios):**
- Es un camino REAL — Sefaria (el referente directo del proyecto) vive de
  fundaciones — pero es lento y condicionado: exige figura legal (A.C. en
  México o *fiscal sponsorship*), historial documentado, gobernanza, y ciclos
  de aplicación de 6–18 meses.
- Encaje imperfecto: los fondos educativos judíos mainstream financian
  proyectos con tracción demostrada; el componente de mazal/carta natal puede
  generar resistencia en fondos ortodoxos. El ángulo fundable más fuerte es
  **"acceso al Zohar y fuentes en español para Latinoamérica"** (equidad
  lingüística — ahí sí hay tesis de fundación).
- Patrocinios comerciales requieren audiencias 10x la actual.
- Crowdfunding temático (p. ej. "el Zohar comentado en español, parashá por
  parashá") es viable a mediano plazo con la audiencia como respaldo.

### Decisión (recomendación entregada)
**No es either/or, es secuencia.** Corto plazo: tzedaká + membresía voluntaria
— TODO el contenido y herramientas siguen gratis; el miembro no compra acceso,
sostiene la obra y recibe el comentario semanal + comunidad (modelo
Wikipedia/Sefaria, compatible con la misión de conocimiento libre). Esa
tracción (donantes, miembros, métricas de uso) ES el expediente que después
abre las puertas institucionales. Largo plazo (6+ meses de datos): dossier
para fundaciones + posible crowdfunding del "Zohar en español". El agente
puede preparar la lista de fondos y requisitos como track paralelo sin frenar
la monetización directa.

---

## D-006 · ¿Monetizar la API del Gran Ciclo como segundo canal? — 2026-07-15

Pregunta del operador: le aseguran que el calendario de 316 ciclos es único en
el mundo y valioso. ¿Existe mercado que pague por acceso vía API? ¿Es viable,
rentable, conviene invertir?

### Verificación de mercado
- **Hebcal** ofrece GRATIS (licencia CC-BY 4.0) APIs de conversión de fechas,
  calendario judío completo, lecturas de Torá y zmanim, más librerías open
  source (@hebcal/core, KosherJava, pyluach) que computan el calendario
  perpetuo para cualquier año. **El precio de mercado de la conversión de
  fechas hebreas es $0.**
- No se detectó ningún proveedor de pago de datos calendáricos hebreos — señal
  de ausencia de disposición a pagar, no de oportunidad vacante.

### Qué es verdad y qué no del "es único en el mundo"
- **Verdad**: como *dataset* curado por capas (2.19M días con posición en el
  ciclo, cuadrante, carácter, fase lunar, eventos históricos, eclipses) y como
  artefacto de ingeniería, es distintivo. Nadie más lo tiene ensamblado así.
- **Matiz honesto**: el cómputo subyacente (calendario de Hillel II) es
  aritmética reproducible por cualquier dev con librerías gratuitas. Y la
  cobertura AM 1–6004 es una *proyección prolepética*: antes de ~359 EC el
  calendario fijo no existía (era observacional), cosa que académicos e
  instituciones religiosas saben. Su valor no es histórico-académico, es
  simbólico/interpretativo.
- **Conclusión**: la unicidad real no está en los datos sino en la **capa
  interpretativa** (carácter del ciclo, ratzo/shov, señales de timing) — y esa
  capa solo vale para quien compra el marco cabalístico, es decir, la
  audiencia B2C propia, no desarrolladores B2B.

### Decisión: NO invertir energía en la API como negocio ahora — mantenerla como opción pasiva
1. El mercado B2B es delgadísimo (apps judías usan Hebcal gratis; plataformas
   espirituales son pocas y de bajo presupuesto) y venderlo exige energía alta
   (outreach, SLAs, docs, billing, uptime en VPS) con retorno esperado de
   0–3 clientes × $29–99/mes en 6 meses. Mal ratio esfuerzo/retorno.
2. El valor real de la DB es ser el **foso competitivo de los productos B2C
   propios** (carta natal, widget del portal, escuela) — eso ya está
   monetizándose vía tzedaká/membresía.
3. **Jugada de bajo costo (~1 h, no semanas)**: publicar la página
   `/gran-ciclo-api` existente como "beta privada — solicita tu key" y
   capturar interés entrante como señal de mercado. Revisar la decisión SOLO
   si llegan 3+ solicitudes serias orgánicas. No construir billing ni
   rate-limiting persistente hasta entonces.
4. Riesgo adicional documentado en el propio go-to-market: acceso bulk barato
   facilita clonar la DB — otra razón para no abrir por volumen.
