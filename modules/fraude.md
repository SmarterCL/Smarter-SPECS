# Módulo: Detector de Fraude

**Archivo:** `api/middleware/fraude.py`

## Propósito

Detectar patrones de fraude conocidos en inputs del usuario.

## Inputs

| Parámetro | Tipo | Descripción |
|---|---|---|
| `input_data` | `dict` | Request body |
| `contexto` | `dict` | Estado del sistema (objetos_usuarios, etc.) |

## Outputs

`list[dict]` — Patrones de fraude detectados.

## Tipos de Patrones

| Tipo | Lógica | Severidad |
|---|---|---|
| `identidad_reusada` | Mismo ID objeto, múltiples usuarios | 2 |
| `cantidad_anomala` | Cantidad > máximo configurado | 2 |
| `precio_fuera_rango` | Precio fuera de min/max | 2 |

## Ejemplo

```python
from api.middleware.fraude import DetectorFraude

detector = DetectorFraude()
detector.registrar_patron("identidad_reusada", {"tipo": "identidad_reusada"})

contexto = {"objetos_usuarios": {"QR-001": ["user1", "user2"]}}
detectados = detector.evaluar({"id_objeto": "QR-001"}, contexto)
# → [{"tipo": "identidad_reusada", "regla": {...}, "severidad": 2}]
```
