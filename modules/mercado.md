# Módulo: Verificador de Mercado

**Archivo:** `api/middleware/mercado.py`

## Propósito

Verificar precios de productos contra tabla de referencia de mercado.

## Inputs

| Parámetro | Tipo | Descripción |
|---|---|---|
| `categoria` | `str` | food, vehicle, reciclaje |
| `producto` | `str` | Nombre del producto |
| `precio` | `float` | Precio en CLP |

## Outputs

```python
{
    "dentro_rango": bool,
    "ratio": float,       # precio / referencia
    "referencia": float,  # precio promedio de mercado
    "observaciones": list[str]
}
```

## Reglas

- ratio > 3.0x → observación de alerta
- ratio < 0.3x → posible dumping
- Sin referencia → dentro_rango = True (sin datos)

## Precios de Referencia (CLP)

| Categoría | Producto | Promedio | Mín | Máx |
|---|---|---|---|---|
| food | hamburguesa | 5,500 | 2,500 | 12,000 |
| food | pizza | 8,000 | 4,000 | 18,000 |
| reciclaje | aluminio | 500/kg | 200 | 1,200 |
| reciclaje | cobre | 4,000/kg | 2,000 | 8,000 |

## Ejemplo

```python
from api.middleware.mercado import VerificadorMercado

v = VerificadorMercado()
r = v.verificar("food", "hamburguesa", 5500)
# → {"dentro_rango": True, "ratio": 1.0, "referencia": 5500}
```
