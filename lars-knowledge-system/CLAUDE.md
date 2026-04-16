# Lars Knowledge System
> Última actualización: 2026-04-16 | Sesión 004

## Proyecto
Herramienta de extracción del conocimiento experto de Lars (auditor de procesos). Captura su metodología en JSON estructurado para usarla como base irrefutable del sistema de auditorías para clientes (Phase 2). **Lo que Lars deposite es la fuente de verdad — no se complementa con frameworks externos.**

## Roles
- **Lars**: experto auditor, co-creador puntual (sesiones acotadas). No participa en Phase 2.
- **Kevin**: constructor del sistema. Facilita sesiones con Lars.
- **Claude**: partner de construcción.

## Stack técnico
- HTML/CSS/JS vanilla (sin frameworks — simplicidad deliberada)
- localStorage (persistencia Phase 1)
- Web Speech API (mic — Chrome/Edge únicamente)
- Export JSON estructurado

## Arquitectura clave
```
/lars-knowledge-system/
  CLAUDE.md                          ← este archivo (contexto de sesión)
  CLAUDE.local.md                    ← overrides personales de Kevin (gitignored)
  /project-state/
    current.md                       ← estado detallado sesión a sesión
  /ui/
    knowledge-capture.html           ← herramienta principal que usa Lars
    demo-feed.html                   ← prototipo card-based APROBADO (pendiente implementar)
  /knowledge-base/
    changelog.md                     ← historial del knowledge base
    /sessions/                       ← output JSON de cada sesión con Lars (vacío aún)
  /.claude/
    /agents/                         ← knowledge-extractor, gap-analyzer
    /commands/                       ← extract-knowledge, gap-analysis, generate-prompt, new-session
    /rules/                          ← agent-usage, methodology-structure, naming-conventions
```

## Estado actual
| Módulo | Estado | Notas |
|--------|--------|-------|
| knowledge-capture.html v2 | ✅ Listo para Lars | Cards 2 col, drag&drop, 34 preguntas, localStorage, mic, historial, proponer proceso, export JSON |
| Primera sesión con Lars | ⏳ Pendiente | Herramienta lista — Lars puede usarla hoy |
| Phase 2 (sistema clientes) | 🔒 Bloqueado | Arranca cuando knowledge base tenga cobertura completa |

## Próximo paso
Recoger feedback de Lars tras su primera sesión de uso real con `knowledge-capture.html` v2 y ajustar lo que haga falta.

## Decisiones tomadas
- Output siempre JSON estructurado (estructura dual: `answer` concatenado + `entries` array con fecha)
- Persistencia Phase 1: localStorage (sin backend)
- Guardado automático y silencioso
- Lars usa laptop/PC (no mobile)
- Export: un archivo JSON por sesión en `/knowledge-base/sessions/session_NNN.json`
- Micrófono: activado en Chrome/Edge, desactivado limpiamente en Firefox
- Phase 1 y Phase 2 son productos distintos — nunca mezclar

## ⚠️ No hacer
- No complementar el conocimiento de Lars con frameworks externos (ISO, etc.) — la metodología de Lars es la fuente única
- No arrancar Phase 2 antes de que todas las secciones del knowledge base estén marcadas como completadas + gap analysis limpio
- No usar backend en Phase 1 — localStorage es suficiente y elimina fricción
- No olvidar correr `/end-session` al cerrar — sin eso la próxima sesión arranca sin contexto

## Reglas de proceso
1. Antes de construir cualquier UI nueva: correr skill `ui-spec`
2. Después de cada build significativo: correr `code-auditor` + `simplify`
3. Al cerrar sesión: correr `end-session` (actualiza este archivo + memory)

## Historial de sesiones
- 2026-04-15: Setup inicial — CLAUDE.md, estructura de carpetas, agents, commands, rules, knowledge-capture.html v1 con UX completo (modal, mic, progreso, log), prototipo card-based demo-feed.html aprobado
- 2026-04-16: Sesión de recuperación — creado CLAUDE.md raíz en audit_lars/, creados archivos de memoria persistente (~/.claude/.../memory/), skill end-session configurado para no volver a perder contexto
