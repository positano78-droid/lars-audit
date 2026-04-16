# /generate-prompt

Convierte la versión activa del knowledge base en un system prompt listo para usar en los agentes de Phase 2.

## Uso
Ejecutar cuando el knowledge base tenga suficiente cobertura para construir el primer borrador del sistema cliente.

## Lo que hace
1. Lee `knowledge-base/versions/lars_vN.json`
2. Extrae la lógica de evaluación, scoring y priorización de Lars
3. Genera un system prompt estructurado que encapsula su metodología
4. Guarda en `/system-prompts/vN.md`

## Output
- `system-prompts/vN.md` — system prompt versionado listo para agentes
