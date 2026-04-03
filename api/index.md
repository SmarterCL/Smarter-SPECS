# Smarter Food API v2.0.0

## Overview

| Property | Value |
|---|---|
| **Framework** | FastAPI (Python) |
| **Version** | 2.0.0 |
| **Port** | 8002 |
| **Service** | `smarter-food.service` (systemd) |
| **URL** | https://food.smarterbot.cl |
| **Docs** | https://food.smarterbot.cl/docs (Swagger) |

## Arquitectura

Nodo de validación universal dentro del **Smarter Fractal Framework**. Implementa un **Contrato de Incoherencia** que valida inputs contra la realidad **antes** de ejecutar cualquier lógica de negocio.

```
Input → [Contrato Incoherencia] → ¿Estado?
  ├─ VALIDADO    → IA scoring (Gemini/Ollama/n8n)
  ├─ SOSPECHOSO  → IA scoring con penalización -20%
  ├─ INCOHERENTE → Bloqueo inmediato (sin IA)
  └─ PENDIENTE   → Cola de revisión humana
```

## Endpoints

| Endpoint | Método | Descripción |
|---|---|---|
| `/` | GET | Landing page |
| `/health` | GET | Health check |
| `/validador` | GET | UI del validador (formulario HTML) |
| `/api/validar` | POST | Endpoint principal de validación |
| `/api/validar/{id_objeto}` | GET | Estado de validación por ID |
| `/api/products` | POST | Crear producto |
| `/api/products` | GET | Listar productos |
| `/api/products/{id}` | GET | Obtener producto por ID |

## Modos de IA

| Modo | Engine | Costo | Estado |
|---|---|---|---|
| `ollama` | Llama 3.2 local | Gratis | ⏳ Requiere Ollama en VPS |
| `gemini` | Gemini 2.5 Flash | API key | ✅ Activo |
| `n8n` | Webhook n8n | Gratis | ⏳ Configurar URL |
| `mock` | Reglas básicas | Gratis | ✅ Fallback |

**Configuración actual:** `AI_MODE=gemini`

## Variables de Entorno

| Variable | Valor Actual | Descripción |
|---|---|---|
| `AI_MODE` | `gemini` | Motor de IA activo |
| `GEMINI_API_KEY` | configurada | Key de Google Gemini |
| `GEMINI_MODEL` | `gemini-2.5-flash` | Modelo Gemini |
| `OLLAMA_URL` | `http://localhost:11434` | Endpoint Ollama |
| `N8N_WEBHOOK_URL` | `https://n8n.smarterbot.cl/webhook/smarter-food` | Webhook n8n |
| `VALIDATOR_URL` | `https://docs.smarterbot.cl/validador` | URL documentación |

## Ejemplos

### Health Check
```bash
curl https://food.smarterbot.cl/health
```
```json
{"status":"ok","service":"smarter-food","ai_mode":"gemini","version":"2.0.0"}
```

### Validar Producto
```bash
curl -X POST https://food.smarterbot.cl/api/validar \
  -H "Content-Type: application/json" \
  -d '{"id_objeto":"QR-001","producto":"Hamburguesa Clásica","peso_gramos":250,"precio":5500,"ubicacion":"Santiago"}'
```

## Estructura del Proyecto

```
/var/www/smarter_latam/
├── PROTOCOLO.md              # Especificación del protocolo
├── api/
│   ├── main.py               # App principal + endpoints + IA engines
│   ├── middleware/
│   │   ├── incoherencia.py   # Contrato de incoherencia (core)
│   │   ├── fraude.py         # Detector de patrones de fraude
│   │   └── mercado.py        # Verificador de precios de mercado
│   ├── models/
│   │   └── schemas.py        # Modelos Pydantic
│   ├── routes/
│   │   ├── validation.py     # Rutas de validación
│   │   └── products.py       # CRUD productos
│   ├── services/
│   │   ├── validator.py      # ValidatorService universal
│   │   └── n8n.py            # N8NWebhookService
│   └── utils/
│       ├── config.py         # Settings
│       └── logger.py         # Logger setup
├── config/
│   └── smarter-food.service  # systemd unit
└── requirements.txt
```
