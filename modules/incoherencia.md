# Módulo: Contrato de Incoherencia

**Archivo:** `api/middleware/incoherencia.py`

## Propósito

Validar coherencia entre input del usuario y realidad del sistema. Gate obligatorio antes de cualquier lógica de negocio.

## Inputs

| Parámetro | Tipo | Descripción |
|---|---|---|
| `input_data` | `dict` | Request body del usuario |
| `contexto` | `dict` | Estado real (DB, históricos, patrones fraude) |
| `env_ok` | `bool` | Si el nodo tiene configuración válida |

## Outputs

`ResultadoContrato` con:
- `estado`: VALIDADO | SOSPECHOSO | INCOHERENTE | PENDIENTE
- `score_incoherencia`: int (0, 1, ≥2, 99)
- `observaciones`: list[str]
- `siguiente_paso`: str

## Reglas

| Score | Estado | Acción |
|---|---|---|
| 0 | VALIDADO | Ejecutar workflow normal |
| 1 | SOSPECHOSO | Sandbox con penalización |
| ≥2 | INCOHERENTE | Bloqueo inmediato |
| 99 | PENDIENTE | Cola humana |

## Ejemplo

```python
from api.middleware.incoherencia import ContratoIncoherencia

contrato = ContratoIncoherencia()
resultado = contrato.evaluar(
    input_data={"id_objeto": "QR-001", "producto": "Hamburguesa", "precio": 5500},
    contexto={"usuarios": {}, "precios_mercado": {...}},
    env_ok=True
)
# → ResultadoContrato(estado=VALIDADO, score_incoherencia=0)
```
