# SEO — que "Zohar Latinoamérica" te encuentre

## El diagnóstico (17 julio 2026)

`site:zoharlatinoamerica.site` devuelve cero resultados: el sitio **no está indexado**.

La primera hipótesis era que Google no sabía que el sitio existía. **Era falsa.**
Search Console lo desmiente:

| URL | Estado en Google |
|---|---|
| `/` | **Rastreada: actualmente sin indexar** — último rastreo 17 jul 2026, 5:51 |
| `/ensayo/`, `/biblioteca/`, `/parasha/` | **Descubierta: actualmente sin indexar** — nunca rastreadas |

Google **rastreó la home el mismo día** y decidió no indexarla. La detectó por el
sitemap y como páginas de referencia el video de YouTube y la página de Facebook.
Es decir: el descubrimiento funciona; lo que falla es que Google **no considera el
sitio suficientemente valioso para indexarlo todavía**.

Esto es lo normal en un dominio nuevo sin autoridad, y es importante entenderlo bien:
ningún ajuste técnico lo fuerza. "Rastreada: actualmente sin indexar" se resuelve con
señales de calidad y autoridad — contenido con sustancia propia y enlaces entrantes
genuinos — no con más metadatos.

Buscar "Zohar Latinoamérica" hoy devuelve kabbalah.info, Kabbalah Centre y Amazon.
Ninguno compite por ese nombre exacto: es tu marca, y una vez indexado es muy ganable.
"Zohar" a secas es otra historia: competidores con años de autoridad, sin atajo técnico.

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
- **Google Search Console**: propiedad de **Dominio** `sc-domain:zoharlatinoamerica.site`
  verificada por DNS, bajo `zoharlatinoamerica@gmail.com`. Sitemap enviado (4 páginas
  descubiertas; el anterior, del builder de Hostinger, era de enero 2025 y descubría 0).
  Las 4 URLs enviadas a la cola de rastreo prioritaria.

## Pendiente

### 1. Google Analytics 4

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

- **Indexación**: días o semanas. Pero ojo — solicitar indexación **pide** una revisión,
  no la garantiza. Como la home ya estaba en "Rastreada: actualmente sin indexar",
  Google ya la evaluó una vez y dijo que no. Si en 2-3 semanas sigue fuera, el problema
  no es técnico y no se arregla reenviando: es de autoridad y contenido.
- **"Zohar Latinoamérica"** → primer puesto es muy alcanzable: es tu marca.
- **"Zohar", "Cábala en español"** → competencia real y establecida. No hay atajo:
  eso se gana con contenido sostenido (la parashá semanal es la mejor apuesta) y
  con enlaces entrantes genuinos.
- **El video**: 117 vistas en 2 semanas con 1.75 K suscriptores. La descripción ya
  enlaza al sitio, que es correcto. Los enlaces de YouTube son `nofollow` (no pasan
  autoridad de posicionamiento) pero sí traen tráfico real y sirven de vía de descubrimiento.

## Lo que de verdad movería la aguja ahora

El techo ya no es técnico — el andamiaje está puesto. Lo que falta es lo que Google
premia y hoy no encuentra:

1. **Contenido propio y sustancial, publicado con constancia.** La parashá semanal es
   la mejor apuesta: es original, tiene fecha, y nadie más la escribe así en español.
   Una página nueva por semana durante unos meses cambia el perfil del dominio.
2. **La biblioteca no puede ser solo enlaces.** Una página que remite a fuentes externas
   es exactamente lo que Google clasifica como de bajo valor. Cada obra necesita texto
   propio: introducción, contexto, comentario.
3. **Enlaces entrantes reales.** Los de YouTube y Facebook son `nofollow`. Hace falta
   que otros sitios citen el ensayo — foros de estudio, blogs de cabalá, universidades.
   Uno bueno vale más que cien de directorios.
4. **El ensayo es el activo más fuerte**: 14 capítulos originales. Merece ser lo que
   se comparte y se cita, no solo lo que se enlaza desde un video.
