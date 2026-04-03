# Estados de Validación

## Principio

**Verdad = coherencia(.env ∩ contexto ∩ input_usuario)**

Si no hay intersección → **rechazo automático** (no excepción, no log).

## Los 4 Estados

### 1. VALIDADO (score_incoherencia = 0)

El input es coherente con la realidad. Se ejecuta scoring con IA.

**Ejemplo de request:**
```json
{
  "id_objeto": "QR-V1",
  "producto": "Hamburguesa Clásica",
  "peso_gramos": 250,
  "precio": 5500,
  "ubicacion": "Santiago"
}
```

**Respuesta:**
```json
{
  "id_objeto": "QR-V1",
  "producto": "Hamburguesa Clásica",
  "score": 8.0,
  "recomendacion": "Una opción sólida y confiable...",
  "observaciones": [
    "El peso de 250g y el precio de $5500 CLP sugieren una relación calidad-cantidad adecuada..."
  ],
  "status": "ok",
  "ai_mode": "gemini",
  "timestamp": "2026-04-03T03:28:32.256389"
}
```

**Acción del sistema:** Ejecutar workflow normal → n8n → Odoo

---

### 2. SOSPECHOSO (score_incoherencia = 1)

Señales de alerta detectadas. IA scoring con penalización del 20%.

**Causas comunes:**
- Precio 3x sobre referencia de mercado
- Sin histórico del usuario
- Cantidad ligeramente anómala

**Ejemplo de request:**
```json
{
  "id_objeto": "QR-S1",
  "producto": "Hamburguesa Clásica",
  "peso_gramos": 250,
  "precio": 18000,
  "ubicacion": "Santiago"
}
```

**Respuesta:**
```json
{
  "id_objeto": "QR-S1",
  "producto": "Hamburguesa Clásica",
  "score": 6.4,
  "recomendacion": "...",
  "observaciones": [
    "Precio $18000 es 3.3x sobre mercado ($5500)",
    "⚠️ Sandbox: precio castigado -20%"
  ],
  "status": "ok",
  "ai_mode": "gemini"
}
```

**Acción del sistema:** Sandbox → precio castigado → revisión

---

### 3. INCOHERENTE (score_incoherencia ≥ 2)

Contradicción detectada. **Bloqueo inmediato — no se llama a IA.**

**Causas comunes:**
- Campos obligatorios vacíos (+1 cada uno)
- Patrón de fraude detectado (+2)
- Mismo ID objeto, múltiples usuarios (+2)
- Precio ≥10x sobre mercado (+2)

**Ejemplo de request:**
```json
{
  "id_objeto": "",
  "producto": "",
  "precio": 60000
}
```

**Respuesta:**
```json
{
  "id_objeto": "",
  "producto": "",
  "score": null,
  "recomendacion": "Input rechazado por incoherencia detectada.",
  "observaciones": [
    "Campo obligatorio vacio: id_objeto",
    "Campo obligatorio vacio: producto",
    "Precio $60000 es 10.0x sobre mercado ($6000)"
  ],
  "status": "rejected",
  "ai_mode": "contrato"
}
```

**Acción del sistema:** Bloqueo → etiqueta de fraude

---

### 4. PENDIENTE (env no configurado)

No se puede verificar. Cola de revisión humana.

**Causa:** Nodo sin `.env` válido (sin GEMINI_API_KEY ni OLLAMA_URL)

**Respuesta:**
```json
{
  "id_objeto": "QR-P1",
  "producto": "Test",
  "score": null,
  "recomendacion": "Validación en cola. Te contactaremos en < 1 hora.",
  "observaciones": ["Nodo sin configuracion valida (.env)"],
  "status": "pending",
  "ai_mode": "pending"
}
```

**Acción del sistema:** Cola → Chatwoot (revisión humana)

---

## Tabla de Scoring

| Verificación fallida | Puntos |
|---|---|
| Campo obligatorio vacío (`id_objeto`, `producto`) | +1 |
| Sin histórico del usuario | +1 |
| Cantidad >5x máximo histórico | +1 |
| Patrón de fraude detectado | +2 |
| Mismo ID, múltiples usuarios | +2 |
| Precio >3x referencia mercado | +1 |
| Precio ≥10x referencia mercado | +2 |

## Umbral de Decisión

| Score Incoherencia | Estado | Acción |
|---|---|---|
| 0 | VALIDADO | IA scoring normal |
| 1 | SOSPECHOSO | IA scoring × 0.8 |
| ≥2 | INCOHERENTE | Bloqueo inmediato |
| 99 | PENDIENTE | Cola humana |
