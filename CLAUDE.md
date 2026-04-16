# audit_lars — Workspace Root

## Qué es este workspace

Proyecto de auditoría de procesos con Lars. Contiene dos elementos:

1. **`lars-knowledge-system/`** — Phase 1: captura del conocimiento experto de Lars en JSON estructurado
2. **`Ejemplo_INFORME[1].docx`** — Ejemplo de informe de auditoría real de referencia
3. **`reunion_auditor_v1.html`** — UI de reunión/auditoría v1 (referencia)

## Regla de cierre de sesión

**Siempre correr `/end-session` al cerrar.** Esto actualiza `project-state/current.md` y los archivos de memoria persistente en `~/.claude/projects/.../memory/`.

Sin este paso, la siguiente sesión arranca sin contexto.

## Contexto activo

Ver `lars-knowledge-system/CLAUDE.md` y `lars-knowledge-system/project-state/current.md` para el estado detallado.

## Estado resumido

- Phase 1 activa: `knowledge-capture.html` operativo
- Próximo paso: implementar diseño card-based (prototipo aprobado en `ui/demo-feed.html`) en `knowledge-capture.html`
