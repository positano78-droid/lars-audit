# /extract-knowledge

Toma el JSON exportado de una sesión con Lars y lo procesa en un archivo de metodología estructurado.

## Uso
Pega el JSON exportado desde knowledge-capture.html y ejecuta este comando.

## Lo que hace
1. Valida la estructura del JSON
2. Extrae las respuestas por sección
3. Identifica campos vacíos o respuestas vagas (menos de 20 palabras en preguntas clave)
4. Genera `/knowledge-base/sessions/session_NNN.json` con el output limpio
5. Actualiza `/project-state/current.md` con el progreso

## Output
- `knowledge-base/sessions/session_NNN.json` — snapshot de la sesión
- Lista de gaps detectados para la próxima sesión con Lars
