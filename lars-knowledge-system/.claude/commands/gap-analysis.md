# /gap-analysis

Analiza el knowledge base actual y detecta huecos, ambigüedades o contradicciones en la metodología de Lars.

## Uso
Ejecutar después de cada sesión de extracción o antes de iniciar la construcción de Phase 2.

## Lo que hace
1. Lee todos los archivos en `/knowledge-base/sessions/`
2. Cruza respuestas entre secciones buscando inconsistencias
3. Detecta preguntas sin responder o con respuestas insuficientes
4. Genera una lista priorizada de gaps con propuesta de pregunta de seguimiento para Lars

## Output
- Lista de gaps críticos (bloquean Phase 2)
- Lista de gaps menores (mejoran la calidad pero no bloquean)
- Preguntas sugeridas para la próxima sesión con Lars
