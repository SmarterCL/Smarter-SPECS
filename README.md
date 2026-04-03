# Smarter-SPECS

Especificaciones técnicas del ecosistema Smarter LATAM.

## Estructura

| Directorio | Contenido |
|---|---|
| `specs/` | Protocolos y especificaciones formales |
| `architecture/` | Infraestructura VPS, servicios, red |
| `api/` | Documentación de APIs (Smarter Food API) |
| `modules/` | Documentación por módulo de código |
| `runbooks/` | Procedimientos operativos |

## Protocolo Smarter v1.0

Ver [`specs/protocolo.md`](specs/protocolo.md)

**Principio:** Verdad = coherencia(.env ∩ contexto ∩ input_usuario)

**4 Estados:** VALIDADO | SOSPECHOSO | INCOHERENTE | PENDIENTE

## Smarter Food API

Ver [`api/index.md`](api/index.md)

- FastAPI v2.0.0 | Port 8002 | Gemini 2.5 Flash
- Contrato de Incoherencia antes de IA
- 4 estados de validación verificados

## Arquitectura VPS

Ver [`architecture/index.md`](architecture/index.md)

- 28 dominios en Caddy
- 22 contenedores Docker
- Ollama + Gemini + n8n + Odoo + Chatwoot

## Reglas Críticas

1. Código sin .md → inválido
2. Cambio en lógica → requiere doc update
3. Doc desactualizada → sistema incoherente
4. Deploy sin doc → FAIL
