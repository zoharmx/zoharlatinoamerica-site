

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

## FASE 4 — ENTREGA 6: PARASHAT KI TEITZEI 5786 (2026-08-20)

Entregada el jueves 20 de agosto, **dos días antes** del Shabat del 22 (9 de
Elul). Se recupera la regla de publicar antes de la lectura; la cadencia
había quedado en pausa desde el 12 de agosto por indisponibilidad del humano.

**Página pública** `/parasha/ki-teitzei-5786/` — «la guerra que se gana por
los que se quedan atrás». Tesis de la entrega: las 74 mitzvot de Ki Teitzei
(la mayor concentración de la Torá, cuenta del Séfer HaJinuj) no son un cajón
de sastre sino un solo mapa — el plural/singular de 21:10 («tus enemigos» /
«lo entregue»), leído con el Zohar como la salida del alma al cuerpo, define
el campo de batalla como el trato con el que está en desventaja. Recorrido:
la cautiva y *lo dibrá Torá elá kenégued yétzer hará* (Rashi 21:11;
Kidushín 21b) con el encadenamiento cautiva → esposa aborrecida → hijo
rebelde; *lo tujal lehitalem*, «no **puedes** desentenderte» (22:3) y *hakem
takim imó* (22:4); el nido (22:6–7) con la prohibición de explicarlo
(Berajot 5:3) y la discusión abierta de Julín 142a; el pretil y *hanofel*
con artículo (22:8); el molino en prenda (24:6), el jornal antes del ocaso
(24:15) y la gavilla olvidada (24:19); y el cierre: las pesas íntegras
(25:13–15) pegadas a Amalek (25:17–18), con Rashi 25:17 sobre la
yuxtaposición (Tanjumá) y Rashi 25:18 sobre *asher karjá* como enfriamiento
— «Amalek no vence: entibia». Haftará (quinta de consuelo): «canta,
estéril» antes de que nazca nadie, «ensancha el lugar de tu tienda» y «mi
bondad no se apartará de ti» (Is 54:1, 54:2, 54:7, 54:10).

**Gran Ciclo** (verificado vía Hebcal el 20 ago): 9 de Elul 5786; año en
posición **10/19** del ciclo **#305**; la posición 10 **no** es embolismal
— 5786 es año regular de 12 meses, sin Adar II, así que Elul corre directo
al juicio. Rosh Hashaná 5787 = **12 de septiembre de 2026**: faltan 21 días.
Luna a un tercio de la crecida (Rosh Jodesh fue el 14 ago), plenilunio en
seis días.

**Paquete editorial completo** (guía de miembros + guion de video +
newsletter) en `Fable 5/parasha/ki-teitzei-5786/`. Se añaden además al
repositorio los paquetes de Devarim y Ékev, que estaban sin versionar.
Redirect de `/parasha/` → `/parasha/ki-teitzei-5786/`; Shoftim archivada;
sitemap regenerado (10 URLs); cero TODOs; `generar-sitemap.sh --check` en
verde.

**Auditoría de indexación (20 ago, medida sobre Google en vivo).** Ocho días
después de publicar Reé y Shoftim, Google sigue con **3 URLs indexadas** —
`/`, `/biblioteca/` y `/parasha/archivo/` — las mismas del 12 de agosto.
Ningún permalink de parashá ha entrado. La causa es identificable: el paso
manual de «Solicitar indexación» en Search Console no se ejecutó. Bing/DDG
sí trae más superficie (home, biblioteca, ensayo, archivo, devarim, ékev),
que es lo que rinde IndexNow. **Hallazgo positivo**: el sitio es hoy el
**resultado #1 de Google para «Zohar Latinoamérica»** — el objetivo de marca
declarado en `SEO.md` está cumplido.

### Pendiente del humano esta semana
1. Checkpoint editorial de Ki Teitzei (doctrina y fuentes).
2. `git push origin main` para desplegar, y después `./indexnow.sh`.
3. **Search Console (cuenta `zoharlatinoamerica@`) — el cuello de botella
   real**: solicitar indexación de `/parasha/ki-teitzei-5786/` y de los cinco
   permalinks anteriores + `/ensayo/`. Sin este paso el contenido semanal no
   entra a Google.
4. Producir y publicar el video de Ki Teitzei (guion listo); siguen sin video
   Ékev, Reé y Shoftim.
5. Enviar la newsletter y la guía a los miembros.

---

## FASE 4 — ENTREGA 7: PARASHAT KI TAVÓ 5786 (2026-08-28)

### Entrega
Séptima entrega del pipeline semanal, y **la primera publicada en la
víspera misma del Shabat de la lectura** (viernes 28 para el Shabat 29) —
dentro de plazo, aunque más ajustado que Ki Teitzei, que salió con dos días
de margen.

**Fecha y lectura** (Hebcal, geonameid 3995465): 16 de Elul 5786 = **sábado
29 de agosto de 2026**, Parashat Ki Tavó, Devarim 26:1–29:8, Haftará
Yeshayahu 60:1–22 (sexta de consuelo). Velas en Monterrey 18:46 del
viernes 28; havdalá 19:38 del sábado 29.

**Título:** «Ki Tavó: lo que faltó no fue obediencia, fue alegría».

**Tesis.** La parashá abre con el canasto de primicias —cuya mitzvá no es
entregar sino **recitar** (Devarim 26:5–10)— y desemboca en la *tojejá*.
El propio texto declara la causa dos veces, y no coinciden: 28:45 dice
«porque no escuchaste», pero **28:47** dice «por cuanto no serviste al
Eterno tu Dios con alegría y con bondad de corazón, *meróv kol*». No acusa
al rebelde: acusa al que cumplió sin alegría teniéndolo todo. El arco cierra
en 29:3–4 — cuarenta años de ropa que no se gastó y «no os dio… ojos para
ver»: la abundancia tan constante que deja de percibirse. De ahí que el
canasto sea el remedio exacto del capítulo 28.

### Hallazgo de fuentes (el bueno de esta semana)
Sefaria **no tiene sección «Zohar, Ki Tavó»** — el índice salta de Ki Teitzei
a Vayeilej. Citarla habría sido inventar. En su lugar, la API de *links* de
Devarim 28:47 devolvió dos pasajes zoháricos reales que comentan el versículo,
y uno es exactamente lo que la entrega necesitaba (**Zohar, Vayishláj**):

> «¿Qué es *meróv kol*? Aquí, *de tanto tenerlo todo*; y allí, *con falta de
> todo*.»

La misma palabra puesta frente a sí misma — la medida por medida del
castigo en una sola palabra repetida. En el mismo pasaje: desde que se
destruyó el Templo «se apartó la alegría de arriba y de abajo».
**Método confirmado:** cuando la sección zohárica homónima no existe, buscar
el versículo por `api/links` en vez de forzar la referencia.

### Fuentes verificadas contra Sefaria (28 ago, una por una)
Devarim 26:1–11, 26:16–19, 27:1–8, 28:45–48, 28:66–69, 29:1–8 (numeración
hebrea confirmada: 28:69 existe, y 29:1 es «Vayikrá Moshé») · Rashi sobre
26:5 (Laván, de Sifrei Devarim 301), 26:16 («cada día nuevos ante tus ojos»,
Tanjumá Ki Tavó 1), 27:8 («*baer heitev*» = setenta lenguas), 28:47
(«mientras tenías todos los bienes») y 29:3 · Mishná Bikurim 3:2–4 (buey de
cuernos dorados, flauta, artesanos de pie, «hasta el rey Agripas» cargando
el canasto) y 3:8 (oro vs. mimbre de sauce) · Sotá 32a (Guerizim/Ebal y las
setenta lenguas) · Meguilá 31b (Ezrá: las maldiciones de Devarim antes de
Rosh Hashaná, «para que termine el año con sus maldiciones»; Leví bar Butí
tartamudeando ante Rav Huná) · Shabat 30b (la Presencia sólo desde la
alegría de una mitzvá; Elishá y el músico, Melajim II 3:15) · Zohar,
Vayishláj · Yeshayahu 60:1–5 y 60:19–22.
**Descartado por no verificable:** la cuenta tradicional de 98 maldiciones
(Baal HaTurim sobre Devarim 28:15 no está en Sefaria) — se escribió «una
lista que no se termina nunca» en vez de dar un número.

### Gran Ciclo (leído de `gran_ciclo_hebreo.db`, no estimado)
Fila real para 16 Elul 5786: `cycle 305`, `pos_cycle 10`, `quadrant 4`,
`year_type Comun`, `mazal ♍ Betulá`, `moon_phase gibosa menguante`.
El dato que hizo la entrega: **el plenilunio de Elul fue el día 15**, así que
esta lectura cae justo cuando la luna empieza a menguar y sigue menguando
hasta Rosh Hashaná — la única fiesta que cae con la luna oculta. Y la
haftará de esta misma semana dice «ni tu luna menguará» (Yeshayahu 60:20).
La coincidencia es estructural, no anecdótica: Ki Tavó se lee siempre en la
segunda mitad de Elul, luego siempre en luna menguante, y siempre trae
«levántate, resplandece». Rosh Hashaná 5787 = 12 sep 2026: **faltan 14 días**.

### Plataforma
- `/parasha/ki-tavo-5786/` publicada; Ki Teitzei archivada con su banda de
  aviso; redirect 302 de `/parasha/` reapuntado; `ensayo/index.html`
  actualizado; ficha e ItemList en `/parasha/archivo/`; `sitemap.xml`
  regenerado (11 URLs). **Cero TODOs**, JSON-LD válido en las tres páginas
  tocadas y etiquetas HTML balanceadas.
- Paquete editorial completo (guía de miembros + guion de video +
  newsletter) en `Fable 5/parasha/ki-tavo-5786/`.
- **Deuda conocida, no introducida esta semana:** `og:image` y el `image` del
  JSON-LD de todos los permalinks apuntan al thumbnail del video de la
  película (`pfRQjh97G7o`). Es la convención vigente del sitio y se corrige
  por página cuando llega el video propio; no se tocó para no divergir.

### Pendiente del humano esta semana
1. Checkpoint editorial de Ki Tavó (doctrina y fuentes) — hoy, antes de las
   velas (18:46).
2. `git push origin main` para desplegar, y después `./indexnow.sh`.
3. **Search Console (cuenta `zoharlatinoamerica@`) — sigue siendo el cuello
   de botella real**: solicitar indexación de `/parasha/ki-tavo-5786/` y de
   los seis permalinks anteriores + `/ensayo/`. La auditoría del 20 de agosto
   dejó claro que sin este paso el contenido semanal no entra a Google.
4. Producir y publicar el video de Ki Tavó (guion listo); siguen sin video
   Ékev, Reé, Shoftim y Ki Teitzei.
5. Enviar la newsletter y la guía a los miembros.
6. **Preparar el cierre del ciclo**: Nitzavim-Vayeilej (5 sep, 23 de Elul) es
   la última entrega de 5786.

### Search Console, 28 ago — se encontró la causa real del estancamiento

El cuello de botella **no era** «nadie pulsa Solicitar indexación». Era el
sitemap.

**Estado al entrar** (propiedad `sc-domain:zoharlatinoamerica.site`, cuenta
`zoharlatinoamerica@gmail.com`): 3 páginas indexadas, 4 no indexadas, 15 clics.

**El hallazgo.** `sitemap.xml` figuraba **enviado el 17 jul 2026** y **leído
por última vez el 18 jul 2026** — 41 días sin releerse — con **4 páginas
descubiertas**. El sitemap desplegado tenía 11 URLs. Es decir: Ékev, Reé,
Shoftim, Ki Teitzei y Ki Tavó **nunca estuvieron en un sitemap que Google
hubiera leído**. Cada inspección de URL lo confirmaba con la línea «No se ha
detectado ningún sitemap de referencia» y el diagnóstico «Google no reconoce
esta URL». Regenerar el sitemap en cada commit no sirve de nada por sí solo:
Google no vuelve a buscarlo, y `robots.txt` declarándolo tampoco bastó.

**La corrección.** Reenviar `https://zoharlatinoamerica.site/sitemap.xml`
desde Search Console → Sitemaps. Google lo releí **en el acto**: la fila pasó
a «28 ago 2026 / 28 ago 2026 / **11 páginas descubiertas**». El efecto fue
inmediato y verificable en la inspección: Shoftim, Reé, Ékev y Vaetjanán
pasaron de «Google no reconoce esta URL» a **«Descubierta: actualmente sin
indexar»**, ya con `sitemap.xml` como fuente de detección.

**Indexación solicitada (8 URLs, todas confirmadas «Se ha solicitado la
indexación»):** ki-tavo, ki-teitzei, shoftim, reé, ékev, vaetjanán, devarim y
`/ensayo/`. Estado previo de cada una: las cinco recientes «no reconocida» o
«descubierta»; devarim y `/ensayo/` **«Rastreada: actualmente sin indexar»**
(rastreadas el 22 y el 17 de julio y descartadas por Google, que es un
problema distinto — de señal, no de descubrimiento).

**Deuda detectada, no tocada:** sigue registrado un `sitemap.rss` enviado el
30 ene 2025 y leído por última vez el 2 mar 2025. Hoy `https://zoharlatinoamerica.site/sitemap.rss`
**responde 404**. Conviene eliminarlo de Search Console (decisión del humano).

**Nota de acceso, para no repetir la búsqueda:** la propiedad vive en
`zoharlatinoamerica@gmail.com`, que **ya está en la sesión del mismo perfil de
Chrome** como cuenta secundaria — se llega por el conmutador de cuentas
(termina en `/u/1/`), sin cambiar de perfil ni volver a iniciar sesión. Y el
enlace profundo `search-console/inspect?resource_id=...&id=...` **devuelve
404**: hay que abrir la propiedad y usar la barra superior «Inspeccionar las
URL de…».

### Añadir al paso 3 del pipeline
Tras cada publicación, además de `./indexnow.sh`: **reenviar el sitemap en
Search Console**. Es un solo campo y arregla el descubrimiento de toda la
semana; pedir indexación URL por URL es el complemento, no el mecanismo.

### Medición del 31 ago 2026 — tres días después del reenvío del sitemap

**El informe «Indexación → Páginas» no sirve para medir esto todavía**: marca
«Última actualización 20/8/26», o sea que su 3 indexadas / 4 sin indexar es
anterior al trabajo del 28. Hay que leer la inspección de URL (consulta el
índice en vivo) y el `site:` público.

**Rastreo — funcionó.** Google rastreó las URLs solicitadas **la misma noche
del 28**, horas después de pedirlo:
- `/parasha/ki-tavo-5786/` → último rastreo **28 ago 2026, 19:26:08**
- `/parasha/ki-teitzei-5786/` → último rastreo **28 ago 2026, 19:30:54**

Ambas con Robot de Google para smartphones, «Obtención de página: Correcto»,
rastreo e indexación permitidos. Estado actual: **«Rastreada: actualmente sin
indexar»** — que es el escalón siguiente a «Google no reconoce esta URL», donde
estaban el 28.

**Indexación — primer resultado.** `site:zoharlatinoamerica.site` devuelve hoy
**4 URLs**, una más que el 20 y el 28 de agosto:
1. `/` · 2. `/biblioteca/` · 3. `/parasha/archivo/` · 4. **`/parasha/ree-5786/` ← nueva**

**Reé es la primera parashá individual que entra al índice.** El 28 de agosto su
inspección decía expresamente «Descubierta: actualmente sin indexar», así que
entró en estos tres días. La coincidencia temporal con el reenvío del sitemap y
la solicitud es fuerte, pero es correlación: Google no explica sus decisiones.

**Lectura:** el problema de **descubrimiento** está resuelto y demostrado — se
rastrea lo que se pide, en horas. El de **valoración** sigue abierto: seis URLs
rastreadas y aún sin indexar. Ahí no hay palanca técnica; son enlaces y
contenido. Próxima medición útil: cuando «Páginas» refresque su fecha.
