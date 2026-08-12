

## FASE 1 — CONSTRUCCIÓN (2026-07-15, en curso)

### Datos reales recibidos del operador

**YouTube (@zoharlatinoamerica, NO monetizado aún):**
- 1,731 suscriptores (+274 en 28 días) — **ya supera el umbral de 1,000 del YPP**
- 14.7K vistas y **2,457 horas de reproducción en solo 28 días** (umbral YPP:
  4,000 h en 12 meses → al ritmo actual de ~88 h/día lo cruza en ~2-3 semanas
  si no lo cruzó ya)
- El motor es UN video: "El Secreto del Sagrado Libro del Zohar (LA PELÍCULA)"
  (2h14m): 14,190 vistas/28d, 118K impresiones, 7.9% CTR, ~959 vistas/48h — 
  YouTube lo está distribuyendo activamente AHORA
- Video nuevo "SEFARAD" (1-jul): retención excelente (45.2% en 15 min) pero
  solo 598 impresiones — necesita empuje desde la película
- Facebook: 3,407 seguidores, actividad baja (35 visitas/28d) — canal secundario

**Análisis honesto:** AdSense a esta escala dará ~$30–90 USD/mes (RPM
espiritualidad ES es bajo). El ingreso real vendrá de donaciones + membresía +
productos. Pero activar YPP es gratis y suma — hay que solicitarlo apenas cruce
las 4,000 h.

### Qué se construyó (portal, rama `fase-1-monetizacion`, commit c77c3b7)
1. **Sección "El tiempo sagrado, hoy"**: día hebreo actual EN VIVO desde la
   API propia del Gran Ciclo (verificada: CORS abierto) + parashá de la semana
   vía Hebcal con velas/havdalá de Monterrey (verificada: Parashat Devarim).
   Diferenciador único: nadie más muestra el ciclo de intercalación #305.
2. **Sección "Sostén este estudio"**: tzedaká de monto libre + membresía
   mensual de la escuela ($5 USD/mes propuesto), vía Stripe Payment Links.
   Config `PAGOS` en JS: sin links todo queda oculto → deploy seguro.
3. **Verificación en navegador local** (localhost:4173): ambos paneles
   renderizan con datos reales, cero errores de consola, sección de pagos
   correctamente oculta sin configurar.

### Qué falló y cómo se corrigió
- Commit vía PowerShell 5.1 rompió por comillas anidadas en `-m` → se usó
  Bash con `git commit -F` y archivo de mensaje.
- La extensión del navegador no permite `file://` → servidor local `npx serve`.

### Estado
🔨 En curso. ~~Bloqueado por checkpoint de Stripe~~ → resuelto, ver Fase 2.

---

## FASE 2 — INFRAESTRUCTURA DE COBRO (2026-07-15) ✅ COMPLETA

### Qué se hizo
El operador entregó su clave secreta de Stripe **en modo live** por chat.
Con ella se creó vía API (curl → api.stripe.com):
- Precio `price_1TtSQgGXeYkobMUF9W6x248j` — Tzedaká, monto libre USD
  (mín $2, sugerido $18) + Payment Link `https://buy.stripe.com/6oU4gzcu6fCI5Nnash2cg00`
- Precio `price_1TtSQhGXeYkobMUFAoVWqyzb` — Membresía $5 USD/mes recurrente
  + Payment Link `https://buy.stripe.com/cNi14nalYbms2Bb9od2cg01`
- Ambos links verificados con HTTP 200 y conectados al portal
  (commit `57e8951` en rama `fase-1-monetizacion`).

### Nota de seguridad (registrada por honestidad del experimento)
La clave compartida es la **secreta live de cuenta completa** y viajó por
chat. Recomendación entregada al operador: rotarla en el dashboard
(Developers → API keys → Roll) cuando terminemos la configuración — los
Payment Links y precios ya creados NO dependen de la clave y seguirán
funcionando. A futuro: claves restringidas por permiso. La clave NO se
guardó en ningún archivo ni repositorio.

### Estado
✅ El sistema puede cobrar. Falta el deploy (Fase 3) — decisión del operador
pendiente sobre qué tarjetas publicar (ver D-005: modelo de financiamiento).

---

## FASE 3 — DESPLIEGUE (2026-07-15) ✅ COMPLETA

### Qué se hizo
1. El operador aprobó la opción (a): desplegar todo.
2. Merge `fase-1-monetizacion` → `main` (commit `865debf`) + push a GitHub →
   deploy automático de Vercel. Verificado en vivo en <1 minuto.
3. **Verificación de producción en navegador real** (zoharlatinoamerica.site):
   - Sección "El cielo hebreo en este instante": 1 Av 5786 AM · Rosh Chodesh ·
     Ciclo #305 año 10/19 (datos vivos de la DB propia) + Parashat Devarim ·
     פרשת דברים · velas/havdalá Monterrey. ✅
   - Sección "Sostén este estudio": ambas tarjetas renderizan; "SOSTÉN"
     activo en la navegación. ✅
   - **Flujo de compra punta a punta**: checkout live de Stripe abre
     correctamente — "Tzedaká · Sostén de Zohar Latinoamérica, USD 18.00,
     importe modificable", formulario de tarjeta y botón Pagar operativos.
     (No se ejecutó pago real; verificación visual del checkout.) ✅

### Evidencia
- Sitio: https://zoharlatinoamerica.site (secciones #tiempo y #sosten)
- Checkout tzedaká: https://buy.stripe.com/6oU4gzcu6fCI5Nnash2cg00
- Checkout membresía: https://buy.stripe.com/cNi14nalYbms2Bb9od2cg01
- Commits: c77c3b7, 57e8951, merge 865debf (repo zoharmx/zoharlatinoamerica-site)

### Estado
✅ EN PRODUCCIÓN. El sistema existe, funciona y puede cobrar. Siguiente:
FASE 4 (motor de distribución).

---

## FASE 4 — MOTOR DE DISTRIBUCIÓN (2026-07-15, primera entrega ✅)

### Decisión previa registrada (D-006)
La API del Gran Ciclo NO se monetiza como negocio B2B por ahora (mercado con
precio $0 — Hebcal es gratuito y CC-BY; la unicidad real está en la capa
interpretativa, que solo vale para la audiencia B2C propia). La DB queda como
foso competitivo de los productos propios.

### Primera entrega del pipeline semanal: PARASHAT DEVARIM 5786
(Shabat Jazón, 18-jul-2026). Paquete completo de 4 piezas:
1. **Página pública** https://zoharlatinoamerica.site/parasha/ — comentario
   con fuentes (Rashi/Sifrei, Zohar-Raaiá Mehemná, Yeshayahu, Berditchever) +
   capa exclusiva del Gran Ciclo (año 10/19 ciclo #305) + CTA membresía.
   DESPLEGADA y verificada (HTTP 200, commit 0cfd08a). El widget del portal
   ahora enlaza aquí. Sitemap actualizado.
2. **Guía de miembros** (producto de la membresía $5/mes): comentario íntegro
   + 5 preguntas de jevruta + práctica de la semana. Local:
   `parasha/devarim-5786/GUIA_MIEMBROS_devarim_5786.md` (no se publica en el
   repo público).
3. **Guion de video** 12–14 min con gancho, 4 bloques, títulos A/B, miniatura,
   descripción y comentario fijado listos para pegar.
4. **Newsletter** con asunto y cuerpo listos para enviar jueves/viernes.

### Infraestructura del motor
`PARASHA_PIPELINE.md`: runbook semanal completo — división agente/humano
(~45 min humanos/semana: revisión doctrinal, producción del video, envíos),
reglas editoriales fijas (fuentes obligatorias, declaración de contenido
sintético), calendario de próximas 5 entregas y métricas a vigilar.

### Estado
✅ Motor operando con su primera entrega. Pendiente del humano esta semana:
producir/publicar el video de Devarim, enviar newsletter, actualizar la
descripción de la película. Siguiente fase del agente: FASE 5 (dashboard de
métricas + OPERATIONS.md + VERIFICATION.md).

---

## FASE 4 — ENTREGA 3: PARASHAT ÉKEV 5786 (2026-07-28)

### Estado de la indexación en Google (verificado hoy, `site:` público)
Cambio real desde el diagnóstico del 17 de julio, cuando el sitio estaba en
cero. Hoy Google devuelve **3 URLs indexadas**:

| URL | Estado |
|---|---|
| `/` | ✅ Indexada — y **posición #1 para «Zohar Latinoamérica»** |
| `/biblioteca/` | ✅ Indexada (fue la primera, 19 jul) |
| `/parasha/archivo/` | ✅ Indexada (creada el 20 jul) |
| `/ensayo/` | ❌ Todavía no |
| `/parasha/` | ❌ Todavía no |
| `/parasha/devarim-5786/` | ❌ Todavía no |

Lectura: la hipótesis de SEO.md se confirmó — el techo no era técnico. Las
dos URLs que entraron después de la biblioteca son las dos que tienen texto
propio y estable. `/parasha/` es sospechosa de no entrar precisamente porque
se sobreescribe cada semana; el archivo por URL permanente (introducido en
`65ac2fc`) es la corrección estructural, y el archivo ya está dentro.

No se pudo entrar a Search Console: el navegador está en `hoymismofletes@` y
la propiedad es de `zoharlatinoamerica@`. Queda como tarea manual del humano.

### Video de Vaetchanan incorporado (`7b5770b`)
`vTCG2vD8CFM` — «Libro del Zohar - Parashá VAETCHANAN y el Shemá», publicado
el Shabat 25 jul. Mismo patrón que Devarim: iframe *nocookie*, `VideoObject`
en `@graph` enlazado al `Article`, og:image al thumbnail, uploadDate en ISO
8601 con zona de Monterrey.

### Entrega 3 del pipeline semanal: PARASHAT ÉKEV
(Shabat 1-ago-2026 · 18 de Av 5786 · Devarim 7:12–11:25 · Haftará Yeshayahu
49:14–51:3 — verificado vía Hebcal.) Paquete completo:
1. **Página pública** `/parasha/` reescrita para Ékev. Vaetchanan archivado en
   `/parasha/vaetchanan-5786/` **con su video**, siguiendo el patrón de
   Devarim. Archivo y sitemap actualizados (7 URLs).
2. **Guía de miembros**, 3. **Guion de video**, 4. **Newsletter** en
   `parasha/ekev-5786/` (no se publican en el repo público).

**Eje de la entrega**: Rashi lee *ékev* como «talón» — las mitzvot ligeras que
el hombre pisa sin verlas — y de ahí cuelga la bendición entera. El Zohar
(Ékev 1, Ra'aya Mehemna) llama *ladrón* al que no bendice, porque la bendición
sostiene el canal; Menajot 43b saca cien bendiciones diarias de *mah*→*me'á*;
Berajot 33b advierte lo inverso (no creer pequeño lo que a Moshé le resultaba
fácil); y la haftará responde a «me olvidaste» con el censo de estrellas de
Berajot 32b. Cierre en cruz: el talón abajo, las estrellas arriba, un solo
principio. Hilo con las dos semanas anteriores: defecto→revelación (Devarim),
negación→abundancia (Vaetchanan), insignificancia→fundamento (Ékev).

**Verificación de fuentes**: todas las citas se contrastaron contra Sefaria
(API) antes de escribir — Rashi 7:12 y 10:12, Devarim 8:3/8:10/10:12, Zohar
Ékev 1, Menajot 43b:15, Berajot 33b:23–25, Berajot 32b:15–17, Taanit 26b:4,
Yeshayahu 49:14–15, Pesikta de-Rav Kahana 17. Cero citas de memoria.

### Pendiente del humano esta semana
1. Revisar doctrina y fuentes de `/parasha/` (checkpoint editorial).
2. Correr `./indexnow.sh` tras el deploy.
3. En Search Console (cuenta `zoharlatinoamerica@`): solicitar indexación de
   `/parasha/vaetchanan-5786/` y **re-solicitar** `/ensayo/`, `/parasha/` y
   `/parasha/devarim-5786/`, que siguen fuera.
4. Producir y publicar el video de Ékev (jue 30 / vie 31), enviar newsletter y
   la guía a los miembros.

---

## FASE 4 — ENTREGA 4: PARASHAT REÉ 5786 (2026-08-12, entregada 4 días tarde)

La cadencia semanal se rompió una vez: Reé (Shabat 8 ago) se entregó el 12 de
agosto, dentro de la semana de Shoftim. Se publicó igual — archivando Ékev —
y al día siguiente se publicó Shoftim a tiempo para su Shabat (15 ago).

**Página pública** `/parasha/ree-5786/` — «la elección que se pone delante de
los ojos». Eje de la entrega: la apertura con un imperativo de vista en
singular («Reé»), Rashi 11:26 (cada uno ve por sí mismo), la elección como
valle entre Gerizim y Ebal (11:29; Zohar, Reé 3:95a), el pecado de
*lehit'alem* — hacerse el que no vio — en la ley de la cosa perdida
(22:1–3), «Jerusalén fue destruida porque no fueron más allá de la línea de
la ley» (Bava Metzia 30b), el diezmo que se puede comprobar (Taanit 9a con
Malaji 3:10), y el arco del ver (Reé) al ser visto (*yera'é*, 16:16).
Haftará (tercera de consuelo): la ciudad de zafiros (Is 54:11–13) y «no leas
*banayich* sino *bonayich*» (Berajot 64a).

**Verificación de fuentes**: Rashi 11:26, 16:19 y 20:8 confirmados contra
Sefaria; Taanit 9a, Sotá 44a y el Tanaj confirmados por la API; el Zohar se
cita a nivel general, sin transcripción inventada. Cero citas de memoria.

## FASE 4 — ENTREGA 5: PARASHAT SHOFTIM 5786 (2026-08-12)

**Página pública** `/parasha/shoftim-5786/` — «la justicia que se aprende a
perseguir». Primera lectura dentro de Elul (2 de Elul). Eje: los jueces
«para ti» en las puertas de la ciudad y del cuerpo (16:18; Zohar, Shoftim
3:95b), *tzedek tzedek tirdof* y el «bet din yafé» de Rashi (16:20;
Sanhedrín 32b), el soborno *she-hu yad* que ciega aun a los sabios (16:19),
el rey que escribe su copia de la Torá (17:16–19; Sanhedrín 21b), el «ni a
derecha ni a izquierda» del Sifrei 154 (17:11), los letreros «refugio» de
Makot 10b (19:3) y el temeroso por sus faltas de Sotá 44a (20:8). Haftará
(cuarta de consuelo): «Yo, yo soy vuestro consolador» — *anojí anojí* contra
*tzedek tzedek* (Is 51:12; 52:1; 52:7).

**Gran Ciclo** (verificado vía API el 12 ago): año 5786, posición 10/19,
ciclo #305; luna menguante en 29 Av; Rosh Jodesh Elul = luna nueva el 14 ago;
en Elul la luna completa un ciclo entero — la imagen de la teshuvá.

**Paquete editorial completo** (guía de miembros + guion de video +
newsletter) en `Fable 5/parasha/ree-5786/` y `Fable 5/parasha/shoftim-5786/`.
Redirect de `/parasha/` → `/parasha/shoftim-5786/`; sitemap regenerado (9
URLs); cero TODOs pendientes; `generar-sitemap.sh --check` en verde.

### Pendiente del humano esta semana
1. Revisar doctrina y fuentes de Reé y Shoftim (checkpoint editorial).
2. Producir y publicar los videos de Reé y Shoftim (guiones listos).
3. Enviar la newsletter y la guía a los miembros.
4. Tras el deploy: `./indexnow.sh`; y en Search Console, solicitar
   indexación de `/parasha/ree-5786/` y `/parasha/shoftim-5786/`.
