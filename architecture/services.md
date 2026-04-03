# Smarter LATAM VPS — Services Catalog

## VPS Overview

| Property | Value |
|---|---|
| **IP** | 89.116.23.167 |
| **Disk** | 78 GB total (59% used) |
| **RAM** | 15 GB total (73% used) |
| **Reverse Proxy** | Caddy |
| **Container Runtime** | Docker |
| **Orchestration** | Dokploy |

---

## Caddy Site Blocks (28 domains)

### AI & Automation

| Domain | Backend | Container / Target |
|---|---|---|
| `dokploy.smarterbot.cl` | `smarter-dokploy:3000` | Docker |
| `n8n.smarterbot.cl` | `172.29.0.3:5678` | Docker (n8n network) |
| `mcp.smarterbot.cl` | `smarter-mcp-optimized:3100` | Docker |
| `llm.smarterbot.cl` | `172.17.0.3:3001` | Docker (bridge network) |
| `rag.smarterbot.cl` | `smarter-docling:8080` | Docker |
| `docling.smarterbot.cl` | `smarter-docling:8080` | Docker (alias) |

### Business Applications

| Domain | Backend | Container / Target |
|---|---|---|
| `api.smarterbot.cl` | `smarteros-api-mcp:3000` | Docker |
| `picoclaw.smarterbot.cl` | `picoclaw-odoo-bridge:4000` | Docker |
| `openspec.smarterbot.cl` | `smarteros-openspec:4321` | Docker |
| `chat.smarterbot.cl` | `chatwoot-app:3000` | Docker |
| `tienda.smarterbot.cl` | `localhost:8069` | Odoo |
| `demo.smarterbot.cl` | `localhost:8069` | Odoo |
| `nunex.smarterbot.cl` | `localhost:8069` | Odoo |

### Admin & Analytics

| Domain | Backend | Container / Target |
|---|---|---|
| `admin.smarterbot.cl` | `smarteros-admin:3000` | Docker |
| `bi.smarterbot.cl` | `smarteros-bi-dashboard:3001` | Docker |
| `pay.smarterbot.cl` | `smarteros-payment-router:3005` | Docker |

### Integrations

| Domain | Backend | Container / Target |
|---|---|---|
| `bot.smarterbot.cl` | `/var/www/bot` | Static files |
| `webcontrol.smarterbot.cl` | `webcontrol-smarterbot:3003` | Docker |
| `claw.smarterbot.cl` | `localhost:18789` | WebSocket |
| `mkt.smarterbot.cl` | `mkt-smarterbot-store:80` | Docker |
| `trello.smarterprop.cl` | `trello-smarterprop:8000` | Docker |
| `ecocupon.smarterbot.cl` | `/var/www/ecocupon` | Static files |
| `docs.smarterbot.cl` | `/var/www/docs` | Static files |
| `food.smarterbot.cl` | `localhost:8002` | Smarter Food API |

### Store / ERP

| Domain | Backend | Container / Target |
|---|---|---|
| `odoo.smarterbot.store` | `localhost:8069` | Odoo |
| `erp.smarterbot.store` | `localhost:8069` | Odoo |

---

## Docker Containers (22)

### Application Containers

| Container | Port | Purpose |
|---|---|---|
| `smarter-dokploy` | 3000 | Deployment dashboard |
| `smarter-mcp-optimized` | 3100 | Model Context Protocol server |
| `smarteros-api-mcp` | 3000 | API gateway |
| `smarteros-openspec` | 4321 | OpenSpec server |
| `smarteros-bi-dashboard` | 3001 | Business Intelligence dashboard |
| `smarteros-payment-router` | 3005 | Payment processing |
| `picoclaw-odoo-bridge` | 4000 | Picoclaw ↔ Odoo bridge |
| `smarter-docling` | 8080 | Document processing (RAG) |
| `bi-webhook-server` | — | BI webhook listener |
| `webcontrol-smarterbot` | 3003 | Web control panel |
| `mkt-smarterbot-store` | 80 | Marketing store |
| `trello-smarterprop` | 8000 | Trello integration |

### Chatwoot Stack

| Container | Purpose |
|---|---|
| `chatwoot-app` | Main Chatwoot application |
| `chatwoot-sidekiq` | Background job processor |
| `chatwoot-worker` | Async task worker |

### Infrastructure Containers

| Container | Port | Purpose |
|---|---|---|
| `odoo` | 8069 | ERP/CRM platform |
| `postgres` | 5432 | PostgreSQL database |
| `redis` | 6379 | Cache & message broker |
| `grafana` | 3000 | Metrics visualization |
| `prometheus` | 9090 | Metrics collection |
| `cadvisor` | 9091 | Container resource monitoring |
| `ollama` | 11434 | Local LLM inference |

---

## Scheduled Tasks (Cron)

| Schedule | Command | Purpose |
|---|---|---|
| `*/5 * * * *` | `.clerk-setup.sh` | Clerk auth sync |
| `0 2 * * *` | `.clerk-email-es-setup.sh` | Daily email config refresh |
| `0 */6 * * *` | `docker system prune` | Clean unused Docker resources |
| `0 3 * * 0` | `docker volume prune` | Weekly orphaned volume cleanup |
