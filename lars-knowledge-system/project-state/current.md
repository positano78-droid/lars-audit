# Estado actual del proyecto

**Última actualización:** 2026-04-16
**Fase activa:** Phase 1 — Lars Knowledge System
**Sesión:** 005

## Dónde estamos

`knowledge-capture.html` v2 — **listo para usar por Lars hoy mismo**.

### Lo que tiene la v2
- Diseño card-based, 2 columnas, drag & drop para reordenar
- 34 preguntas reales de metodología (8 secciones)
- localStorage completo — todo persiste entre sesiones
- Tracking de sesiones (cada día = nueva sesión numerada)
- Historial por pregunta: modal con entradas anteriores, fecha y nº de sesión
- Micrófono (Chrome/Edge) con detección automática
- Alerta si respuesta < 15 palabras
- "Proponer nuevo proceso" — Lars describe el proceso, el sistema genera 5-6 preguntas automáticamente y las añade como cards nuevas
- Export JSON completo con estructura dual (answer + entries[])
- Instrucciones siempre visibles en la cabecera

### Flujo de sesión con Lars
1. Lars abre `knowledge-capture.html` en Chrome/Edge
2. Responde las cards que quiera en cualquier orden
3. Al terminar, pulsa "Exportar JSON" → descarga `lars_session_N_YYYY-MM-DD.json`
4. Kevin mueve ese archivo a `knowledge-base/sessions/`
5. Cuando haya sesiones suficientes, correr el agente `knowledge-extractor`

## Próxima sesión arranca desde

Recoger feedback de Lars tras su primera sesión de uso real y ajustar lo que haga falta.

## Decisiones tomadas

- Storage key: `lks_v2` (no conflicta con datos de v1)
- Persistencia: localStorage (no requiere backend)
- Sesión = día: si Lars abre en un día diferente, el sistema incrementa el contador de sesión automáticamente
- Export JSON: estructura dual `answer` (concatenado) + `entries[]` (array con fecha, sesión, palabras)
- Generación de preguntas para nuevos procesos: template inteligente (sin API — funciona offline)
- Micrófono: sólo Chrome/Edge. En otros browsers, toast informativo sin romper nada
