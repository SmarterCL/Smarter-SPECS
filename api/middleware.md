# Middleware — Contrato de Incoherencia

## Visión General

El middleware de incoherencia es un **gate obligatorio** que todo input debe pasar **antes** de cualquier lógica de negocio. No es middleware de FastAPI en el sentido técnico — es una capa de validación que se ejecuta dentro de cada endpoint.

**Regla de oro:** incoherencia BLOQUEA, no loguea.

## Componentes

### 1. ContratoIncoherencia (`incoherencia.py`)

Clase principal que evalúa la coherencia del input.

```python
contrato = ContratoIncoherencia()
resultado = contrato.evaluar(input_data, contexto, env_ok())
```

**Método `evaluar()`:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `input_data` | `dict` | Datos del usuario (request body) |
| `contexto` | `dict` | Estado real del sistema (DB, históricos) |
| `env_ok` | `bool` | Si el .env del nodo está configurado |

**Retorna:** `ResultadoContrato` con estado, score y observaciones.

**Verificaciones (en orden):**

1. **ENV** — ¿El nodo tiene sus axiomas configurados?
2. **Campos obligatorios** — `id_objeto` y `producto` no vacíos
3. **Estado** — Consistencia con histórico del usuario
4. **Fraude** — Patrones conocidos detectados
5. **Mercado** — Precio vs referencia

### 2. DetectorFraude (`fraude.py`)

Detector de patrones de fraude reutilizable.

```python
detector = DetectorFraude()
detector.registrar_patron("identidad_reusada", {"tipo": "identidad_reusada"})
detectados = detector.evaluar(input_data, contexto)
```

**Tipos de reglas soportados:**

| Tipo | Lógica |
|---|---|
| `identidad_reusada` | Mismo ID objeto, múltiples usuarios |
| `cantidad_anomala` | Cantidad excede máximo configurado |
| `precio_fuera_rango` | Precio fuera de min/max |

### 3. VerificadorMercado (`mercado.py`)

Verificación de precios contra tabla de referencia.

```python
verificador = VerificadorMercado()
resultado = verificador.verificar("food", "hamburguesa", 5500)
# → {"dentro_rango": True, "ratio": 1.0, "referencia": 5500}
```

**Tabla de precios (CLP):**

| Categoría | Producto | Promedio | Mín | Máx |
|---|---|---|---|---|
| food | hamburguesa | 5,500 | 2,500 | 12,000 |
| food | pizza | 8,000 | 4,000 | 18,000 |
| food | sushi | 10,000 | 5,000 | 25,000 |
| food | ensalada | 4,500 | 2,000 | 9,000 |
| reciclaje | aluminio | 500/kg | 200 | 1,200 |
| reciclaje | cobre | 4,000/kg | 2,000 | 8,000 |
| reciclaje | carton | 50/kg | 20 | 120 |

## Umbrales

| Umbral | Valor | Efecto |
|---|---|---|
| `sospechoso` | 1 | Score = 1 → SOSPECHOSO |
| `incoherente` | 2 | Score ≥ 2 → INCOHERENTE |
| `precio_mult_warn` | 3.0x | Precio 3x mercado → +1 punto |
| `precio_mult_reject` | 10.0x | Precio ≥10x mercado → +2 puntos |

## Flujo de Ejecución

```
POST /api/validar
  │
  ├─ 1. contrato.evaluar(input, contexto, env_ok)
  │     │
  │     ├─ score = 0 → VALIDADO → ir a paso 2
  │     ├─ score = 1 → SOSPECHOSO → continuar con penalización
  │     └─ score ≥ 2 → INCOHERENTE → retornar rechazo (fin)
  │
  ├─ 2. IA scoring (gemini/ollama/n8n/mock)
  │     │
  │     ├─ Si SOSPECHOSO → score × 0.8
  │     └─ Si VALIDADO → score normal
  │
  └─ 3. Retornar ValidacionResponse
```

## Extensibilidad

Para agregar una nueva verificación:

1. Agregar método `_verificar_xxx()` en `ContratoIncoherencia`
2. Llamarlo en `evaluar()` sumando puntos al score
3. Actualizar `PROTOCOLO.md` con la nueva regla

Cada verificación debe retornar: `{"puntos": int, "observaciones": list}`
