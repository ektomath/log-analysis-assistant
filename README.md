# Log Analysis Assistant

A one-month learning project for practising the skills behind an AI/data engineering role: Docker, data pipelines (Airflow), RAG, MCP, AI agents, Kubernetes, Helm and CI.

The project builds a local assistant that ingests real system logs, makes them searchable with SQL and vector search, and lets an AI agent investigate them through tools exposed over MCP.

## Constraints

- **Time:** about 20 hours a week for 4 weeks (~80 hours total).
- **Hardware:** runs fully locally on a machine with 8 GB VRAM. Cloud compute is a fallback, not a requirement.
- **Focus:** infrastructure and GenAI. Classic ML (for example failure prediction) is out of scope for now.

## Stack

| Area | Choice |
| --- | --- |
| Data | [Loghub](https://github.com/logpai/loghub) public system logs (HDFS, OpenStack, Linux) |
| Storage | PostgreSQL with the `pgvector` extension |
| Pipeline | Apache Airflow (fallback: a plain Python ETL script) |
| LLM | [Ollama](https://ollama.com) running a 7–8B quantized model (Qwen or Llama) |
| Embeddings | A small local embedding model (for example `nomic-embed-text` via Ollama) |
| Tools | An MCP server written in Python |
| Agent | LangGraph or a plain tool-calling loop |
| Containers | Docker and Docker Compose |
| Orchestration | Kubernetes (kind or minikube) and Helm |
| CI | GitHub Actions |

## Getting started

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (on Windows, with the WSL 2 backend)

### Start the database

```bash
cp .env.example .env        # PowerShell: Copy-Item .env.example .env
docker compose up -d
docker compose ps           # wait until postgres shows "healthy"
```

### Connect with psql

```bash
docker compose exec postgres psql -U loguser -d logs
```

Check that pgvector is enabled:

```sql
SELECT extname, extversion FROM pg_extension WHERE extname = 'vector';
```

### Stop

```bash
docker compose down         # stop containers, keep data
docker compose down -v      # stop and delete all data
```

The init scripts in `db/init/` only run when the data volume is first created. After changing them, reset with `docker compose down -v`.

## Plan

### Week 1: Docker and the data pipeline

- Containerize the stack with Docker Compose: Postgres (with pgvector) and a small Airflow setup.
- Write an Airflow DAG that downloads the raw logs, parses them into structured rows (timestamp, component, level, message template) and loads them into SQL tables.
- If Airflow takes too much time, replace it with a plain Python ETL script and move on.

**Done when:** `docker compose up` brings up the stack and the logs are queryable in Postgres.

### Week 2: RAG

- Embed log templates and reference docs (for example Hadoop and OpenStack documentation) into pgvector using a local embedding model.
- Build a retrieval and answer flow that can answer questions like "what does this error mean and where does it show up?"
- Create a small hand-made evaluation set and measure retrieval quality instead of eyeballing it.

**Done when:** questions return grounded answers with sources, and there is a retrieval score to improve against.

### Week 3: MCP and the agent

- Write an MCP server that exposes tools:
  - run a read-only SQL query on the logs
  - semantic search over logs and docs
  - error statistics for a time window
- Build an agent that uses these tools to investigate questions like "why did errors spike on day X?"
- Connect the same MCP server to another MCP client (for example Claude Desktop) to check that it works across clients.

**Done when:** the agent can answer a multi-step investigation question by calling the tools.

### Week 4: Kubernetes, Helm and CI

- Run a local cluster with kind or minikube.
- Write Kubernetes manifests for Postgres, the MCP server and the agent API.
- Package them as a simple Helm chart.
- Add a GitHub Actions workflow that runs tests and builds the Docker images.

**Done when:** `helm install` deploys the stack to the local cluster and CI passes on every push.

## Progress

- [ ] Week 1: Docker and the data pipeline
- [ ] Week 2: RAG
- [ ] Week 3: MCP and the agent
- [ ] Week 4: Kubernetes, Helm and CI
