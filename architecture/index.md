# Smarter LATAM VPS — Infrastructure Overview

## Server

| Property | Value |
|---|---|
| **IP Address** | 89.116.23.167 |
| **Disk** | 78 GB total (59% used) |
| **RAM** | 15 GB total (73% used) |
| **OS** | Linux |
| **Reverse Proxy** | Caddy (automatic HTTPS) |
| **Container Runtime** | Docker |
| **Orchestration** | Dokploy |

## Architecture Summary

The VPS runs a single Caddy reverse proxy that terminates HTTPS for **28 domains** and routes traffic to:

- **Docker containers** (22 total) — application services, databases, and monitoring
- **Localhost services** — Odoo ERP instances and internal APIs
- **Static file directories** — `/var/www/bot`, `/var/www/ecocupon`, `/var/www/docs`

## Key Capabilities

| Capability | Services |
|---|---|
| **AI / LLM** | Ollama, MCP Server, LLM Gateway, Docling (RAG) |
| **Automation** | n8n workflows, Chatwoot support platform |
| **ERP / CRM** | Odoo (multi-instance: tienda, demo, nunex, odoo.store, erp.store) |
| **Payments** | Payment Router |
| **Analytics** | Grafana, Prometheus, cAdvisor, BI Dashboard |
| **Integrations** | Trello, Picoclaw bridge, Marketing store |
| **Documentation** | OpenSpec, static docs site |

## Service Categories

```
Caddy (:443)
├── AI Stack
│   ├── ollama (11434)
│   ├── LLM Gateway (3001)
│   ├── MCP Server (3100)
│   └── Docling / RAG (8080)
│
├── Business Apps
│   ├── Odoo ×5 instances (8069)
│   ├── Chatwoot stack (3000)
│   ├── n8n (5678)
│   └── API Gateway (3000)
│
├── Integrations
│   ├── Picoclaw Bridge (4000)
│   ├── Trello (8000)
│   ├── WebControl (3003)
│   └── Marketing Store (80)
│
├── Admin & Analytics
│   ├── Admin Panel (3000)
│   ├── BI Dashboard (3001)
│   └── Payment Router (3005)
│
├── Monitoring
│   ├── Grafana (3000)
│   ├── Prometheus (9090)
│   └── cAdvisor (9091)
│
└── Static Sites
    ├── /var/www/bot
    ├── /var/www/ecocupon
    └── /var/www/docs
```

## Data Layer

| Service | Port | Role |
|---|---|---|
| PostgreSQL | 5432 | Primary relational database |
| Redis | 6379 | Cache, sessions, message queue |

## Documentation Index

| Document | Description |
|---|---|
| [Services](./services.md) | Full catalog of 28 Caddy domains + 22 Docker containers |
| [Network](./network.md) | Port map, internal services, traffic flow diagrams |
