-- Runs once, when the Postgres data volume is first created.
-- Enables pgvector so we can store embeddings later (Week 2).
CREATE EXTENSION IF NOT EXISTS vector;
