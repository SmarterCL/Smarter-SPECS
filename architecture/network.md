# Smarter LATAM VPS — Network Map

## External Ports

| Port | Protocol | Service | Notes |
|---|---|---|---|
| 80 | TCP | Caddy | HTTP → HTTPS redirect |
| 443 | TCP | Caddy | HTTPS (all 28 domains) |

## Internal Service Ports

| Port | Service | Container / Host | Purpose |
|---|---|---|---|
| 3000 | Grafana | `grafana` | Metrics dashboard |
| 3001 | LLM Gateway | `172.17.0.3` | LLM inference API |
| 3005 | Payment Router | `smarteros-payment-router` | Payment processing |
| 3100 | MCP Server | `smarter-mcp-optimized` | Model Context Protocol |
| 4000 | Odoo Bridge | `picoclaw-odoo-bridge` | Picoclaw integration |
| 4321 | OpenSpec | `smarteros-openspec` | Spec server |
| 5678 | n8n | `172.29.0.3` | Workflow automation |
| 8000 | Trello | `trello-smarterprop` | Trello integration |
| 8002 | Food API | `localhost` | Smarter Food API |
| 8069 | Odoo | `localhost` | ERP/CRM (3 instances) |
| 8080 | Docling | `smarter-docling` | Document processing |
| 9090 | Prometheus | `prometheus` | Metrics collection |
| 9091 | cAdvisor | `cadvisor` | Container monitoring |
| 11434 | Ollama | `ollama` | Local model serving |
| 18789 | WebSocket | `localhost` | Claw WebSocket service |

## Data Store Ports

| Port | Service | Container | Purpose |
|---|---|---|---|
| 5432 | PostgreSQL | `postgres` | Primary database |
| 6379 | Redis | `redis` | Cache & message queue |

---

## Docker Networks

Services communicate across Docker's internal networks. Key network segments:

| Network | Subnet (typical) | Services |
|---|---|---|
| `bridge` (default) | 172.17.0.0/16 | LLM gateway, core services |
| `n8n network` | 172.29.0.0/16 | n8n and related services |
| `dokploy` | — | Dokploy-managed containers |

## Traffic Flow

```
Client
  │ HTTPS (:443)
  ▼
┌─────────────────────────────────────────┐
│  Caddy (reverse proxy)                  │
│                                         │
│  Routes to:                             │
│  ├─ Docker containers (internal IPs)    │
│  ├─ localhost services (Odoo, APIs)     │
│  └─ Static file directories             │
└─────────────────────────────────────────┘
       │              │              │
       ▼              ▼              ▼
  ┌─────────┐  ┌──────────┐  ┌───────────┐
  │ Docker   │  │ Localhost│  │ /var/www  │
  │ Services │  │ Services │  │ (static)  │
  └─────────┘  └──────────┘  └───────────┘
```

## Service Dependencies

```
postgres (5432) ──┬──► Odoo (8069)
                   ├──► Chatwoot stack
                   └──► BI Dashboard

redis (6379) ─────┬──► Chatwoot sidekiq
                   ├──► Chatwoot worker
                   └──► n8n

ollama (11434) ───► LLM Gateway (3001) ──► MCP Server (3100)

prometheus (9090) ◄── cAdvisor (9091)
                  ◄── Grafana (3000) [datasource]
```
