# Cuándo usar cada agente

| Agente | Cuándo invocarlo |
|---|---|
| `knowledge-extractor` | Tras exportar JSON de una sesión con Lars |
| `gap-analyzer` | Antes de cada sesión con Lars y antes de arrancar Phase 2 |
| `intake-agent` | Phase 2 — cuando se arranca una auditoría de cliente nueva |
| `analysis-agent` | Phase 2 — cuando el cliente completa el intake |
| `report-agent` | Phase 2 — para generar el informe final |
| `feedback-agent` | Phase 2 — tras entregar un informe, para extraer aprendizajes |

## Regla general
Los agentes de Phase 2 no existen todavía. Se construirán una vez el knowledge base de Lars tenga cobertura suficiente (todas las secciones marcadas como completadas + gap analysis limpio).
