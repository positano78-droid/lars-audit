# Lars Knowledge System
> Última actualización: 2026-04-16 | Sesión 005

## Proyecto
Herramienta de extracción del conocimiento experto de Lars (auditor de procesos). Captura su metodología en JSON estructurado para usarla como base irrefutable del sistema de auditorías para clientes (Phase 2). **Lo que Lars deposite es la fuente de verdad — no se complementa con frameworks externos.**

## Roles
- **Lars**: experto auditor, co-creador puntual (sesiones acotadas). No participa en Phase 2.
- **Kevin**: constructor del sistema. Facilita sesiones con Lars.
- **Claude**: partner de construcción.

## Stack técnico
- HTML/CSS/JS vanilla (sin frameworks — simplicidad deliberada)
- Supabase (Postgres + Storage) — backend cloud Phase 1
- localStorage (fallback offline)
- Web Speech API (mic — Chrome/Edge únicamente)
- Export JSON estructurado
- Vercel (deploy estático — repo: positano78-droid/lars-audit)

## Arquitectura clave
```
/audit_lars/                         ← raíz del repo (positano78-droid/lars-audit en GitHub)
  vercel.json                        ← apunta outputDirectory a lars-knowledge-system/ui
  .gitignore                         ← excluye Password*.docx y settings.local.json
  /lars-knowledge-system/
    CLAUDE.md                        ← este archivo (contexto de sesión)
    CLAUDE.local.md                  ← overrides personales de Kevin (gitignored)
    /project-state/
      current.md                     ← estado detallado sesión a sesión
    /ui/
      index.html                     ← herramienta principal (antes knowledge-capture.html)
      knowledge-capture.html         ← copia de backup
      demo-feed.html                 ← prototipo card-based (referencia)
    /knowledge-base/
      supabase-setup.sql             ← schema completo + migraciones + vistas
      changelog.md
      /sessions/                     ← output JSON de cada sesión con Lars
    /.claude/
      /agents/                       ← knowledge-extractor, gap-analyzer
      /commands/                     ← extract-knowledge, gap-analysis, generate-prompt, new-session
      /rules/                        ← agent-usage, methodology-structure, naming-conventions
```

### Supabase — tablas
- `sessions` — una fila por día de uso
- `entries` — respuestas de Lars (con `section`, `question_title`)
- `question_state` — marcar pregunta como completada
- `custom_questions` — preguntas propuestas por Lars
- `question_order` — orden de las cards (fila única id=1)
- `rag_documents` — metadatos de docs subidos (con `doc_type`)
- `doubts` — dudas/notas libres de Lars
- Vista `section_coverage` — cobertura por sección

## Estado actual
| Módulo | Estado | Notas |
|--------|--------|-------|
| index.html (herramienta Lars) | ✅ Desplegado en Vercel | Supabase conectado, sync fiable, borrados corregidos |
| Supabase schema | ✅ Completo | 7 tablas + vista section_coverage, migraciones aplicadas |
| GitHub repo | ✅ Activo | positano78-droid/lars-audit, Vercel auto-deploy en push |
| Primera sesión con Lars | ⏳ Pendiente | Enviar URL de Vercel a Lars |
| Phase 2 (sistema clientes) | 🔒 Bloqueado | Arranca cuando knowledge base tenga cobertura completa |

## Próximo paso
Enviar la URL de Vercel a Lars para que empiece su primera sesión real y recoger feedback.

## Decisiones tomadas
- Output siempre JSON estructurado (estructura dual: `answer` concatenado + `entries` array con fecha)
- Persistencia: Supabase como fuente de verdad, localStorage como fallback offline
- Guardado automático y silencioso
- Lars usa laptop/PC (no mobile)
- Export: un archivo JSON por sesión en `/knowledge-base/sessions/session_NNN.json`
- Micrófono: activado en Chrome/Edge, desactivado limpiamente en Firefox
- Phase 1 y Phase 2 son productos distintos — nunca mezclar
- Una sola tabla `entries` (no una por sección) — más simple, soporta custom questions, section_coverage view lo agrupa
- Borrados en UI siempre sincronizan a Supabase (sin gate cloudOk), con retry automático x3

## ⚠️ No hacer
- No complementar el conocimiento de Lars con frameworks externos (ISO, etc.) — la metodología de Lars es la fuente única
- No arrancar Phase 2 antes de que todas las secciones del knowledge base estén marcadas como completadas + gap analysis limpio
- No proponer tablas separadas por sección — decisión tomada, una tabla entries con columna section es suficiente
- No olvidar correr `/end-session` al cerrar — sin eso la próxima sesión arranca sin contexto

## Reglas de proceso
1. Antes de construir cualquier UI nueva: correr skill `ui-spec`
2. Después de cada build significativo: correr `code-auditor` + `simplify`
3. Al cerrar sesión: correr `end-session` (actualiza este archivo + memory)

## Historial de sesiones
- 2026-04-15: Setup inicial — CLAUDE.md, estructura de carpetas, agents, commands, rules, knowledge-capture.html v1 con UX completo (modal, mic, progreso, log), prototipo card-based demo-feed.html aprobado
- 2026-04-16 (AM): Sesión de recuperación — creado CLAUDE.md raíz en audit_lars/, creados archivos de memoria persistente (~/.claude/.../memory/), skill end-session configurado
- 2026-04-16 (PM): Supabase integrado — schema completo (7 tablas + vistas), bugs de sync corregidos, index.html creado, vercel.json configurado, repo subido a GitHub (positano78-droid/lars-audit), desplegado en Vercel
