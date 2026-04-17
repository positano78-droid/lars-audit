-- ══════════════════════════════════════════════════════════
--  Lars Knowledge System — Supabase schema
--  Instrucciones: pega este SQL en Supabase > SQL Editor > New query > Run
-- ══════════════════════════════════════════════════════════

-- 1. Sesiones (una por día)
create table if not exists sessions (
  id          uuid primary key default gen_random_uuid(),
  n           integer not null,
  date        text not null,          -- "2026-04-16"
  created_at  timestamptz default now()
);

-- 2. Entradas de Lars (texto guardado por pregunta)
create table if not exists entries (
  id             uuid primary key default gen_random_uuid(),
  question_id    text not null,         -- "q1_1", "custom_xxx"
  date_label     text,                  -- "16 abr. 2026"
  iso_date       text,                  -- "2026-04-16"
  session_n      integer,
  text           text,
  words          integer,
  section        text,                  -- sección a la que pertenece la pregunta
  question_title text,                  -- título legible de la pregunta
  created_at     timestamptz default now()
);
create index if not exists entries_question_id_idx on entries(question_id);

-- 3. Estado de cada pregunta (completada o no)
create table if not exists question_state (
  question_id  text primary key,
  is_done      boolean default false,
  updated_at   timestamptz default now()
);

-- 4. Preguntas personalizadas propuestas por Lars
create table if not exists custom_questions (
  id          text primary key,       -- "custom_1713300000000_0"
  sec         text,
  title       text,
  ctx         text,
  is_new      boolean default true,
  created_at  timestamptz default now()
);

-- 5. Orden de las cards (fila única, id = 1 siempre)
create table if not exists question_order (
  id           integer primary key default 1,
  order_array  jsonb,                 -- ["q1_1","q1_2",...,"custom_xxx"]
  updated_at   timestamptz default now()
);

-- 6. Metadatos de documentos subidos al RAG Space
create table if not exists rag_documents (
  id          uuid primary key default gen_random_uuid(),
  name        text,
  description text,
  file_path   text,                   -- path dentro del bucket rag-documents
  file_size   bigint,
  mime_type   text,
  doc_type    text,                   -- "informe", "plantilla", "referencia", etc.
  created_at  timestamptz default now()
);

-- 7. Dudas y notas libres de Lars (pestaña Dudas)
create table if not exists doubts (
  id          uuid primary key default gen_random_uuid(),
  text        text not null,
  session_n   integer,
  date_label  text,
  iso_date    text,
  words       integer,
  created_at  timestamptz default now()
);

-- 8. Registro de cards eliminadas por Lars (auditoría)
create table if not exists deleted_cards (
  id             uuid primary key default gen_random_uuid(),
  question_id    text not null,         -- ID original de la card ("q1_1", "custom_xxx")
  question_title text,                  -- texto de la pregunta
  section        text,                  -- sección a la que pertenecía
  is_custom      boolean default false, -- true si era una pregunta propuesta por Lars
  session_n      integer,               -- sesión en la que se eliminó
  date_label     text,                  -- "17 abr. 2026"
  reason         text,                  -- motivo escrito por Lars (opcional)
  deleted_at     timestamptz default now()
);

-- ── RLS (Row Level Security) ──
-- Activar RLS en todas las tablas
alter table sessions         enable row level security;
alter table entries          enable row level security;
alter table question_state   enable row level security;
alter table custom_questions enable row level security;
alter table question_order   enable row level security;
alter table rag_documents    enable row level security;
alter table doubts           enable row level security;
alter table deleted_cards    enable row level security;

-- Permitir todo al rol anon (Phase 1 — herramienta de un solo usuario, sin login)
-- Drop primero por si ya existen de una ejecución anterior
drop policy if exists "anon_all_sessions"         on sessions;
drop policy if exists "anon_all_entries"          on entries;
drop policy if exists "anon_all_question_state"   on question_state;
drop policy if exists "anon_all_custom_questions" on custom_questions;
drop policy if exists "anon_all_question_order"   on question_order;
drop policy if exists "anon_all_rag_documents"    on rag_documents;
drop policy if exists "anon_all_doubts"           on doubts;
drop policy if exists "anon_all_deleted_cards"    on deleted_cards;

create policy "anon_all_sessions"         on sessions         for all to anon using (true) with check (true);
create policy "anon_all_entries"          on entries          for all to anon using (true) with check (true);
create policy "anon_all_question_state"   on question_state   for all to anon using (true) with check (true);
create policy "anon_all_custom_questions" on custom_questions  for all to anon using (true) with check (true);
create policy "anon_all_question_order"   on question_order   for all to anon using (true) with check (true);
create policy "anon_all_rag_documents"    on rag_documents    for all to anon using (true) with check (true);
create policy "anon_all_doubts"           on doubts           for all to anon using (true) with check (true);
create policy "anon_all_deleted_cards"    on deleted_cards    for all to anon using (true) with check (true);

-- ── Storage bucket ──
-- Crea el bucket manualmente en Supabase > Storage > New bucket
-- Nombre: rag-documents
-- Tipo: Private (para URLs firmadas) o Public (para URLs directas)
-- Tras crearlo, añade esta policy en Storage > Policies:
--   Bucket: rag-documents | Operation: ALL | Role: anon | USING: true

-- ══════════════════════════════════════════════════════════
--  MIGRACIONES — columnas añadidas tras el setup inicial
--  Safe de ejecutar múltiples veces (IF NOT EXISTS)
-- ══════════════════════════════════════════════════════════
alter table entries       add column if not exists section        text;
alter table entries       add column if not exists question_title text;
alter table rag_documents add column if not exists doc_type       text;

-- Migración: tabla deleted_cards (2026-04-17)
-- Si ya corriste el setup completo arriba, esta línea es redundante pero segura
create table if not exists deleted_cards (
  id             uuid primary key default gen_random_uuid(),
  question_id    text not null,
  question_title text,
  section        text,
  is_custom      boolean default false,
  session_n      integer,
  date_label     text,
  reason         text,
  deleted_at     timestamptz default now()
);
alter table deleted_cards enable row level security;
drop policy if exists "anon_all_deleted_cards" on deleted_cards;
create policy "anon_all_deleted_cards" on deleted_cards for all to anon using (true) with check (true);

-- ══════════════════════════════════════════════════════════
--  VISTA — section_coverage
-- ══════════════════════════════════════════════════════════
drop view if exists section_coverage;

create or replace view section_coverage as
select
  e.section,
  count(distinct e.question_id) as questions_answered,
  sum(e.words)                  as total_words,
  bool_and(coalesce(qs.is_done, false)) as section_complete
from entries e
left join question_state qs on qs.question_id = e.question_id
group by e.section
order by e.section;
