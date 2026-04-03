# Runbook: Deploy Smarter Food API

## Pre-requisitos

- [ ] Código en `/var/www/smarter_latam/api/`
- [ ] `.env` configurado (GEMINI_API_KEY, AI_MODE)
- [ ] Documentación actualizada en `/var/www/docs/`

## Pasos

### 1. Verificar código
```bash
cd /var/www/smarter_latam
/var/www/smarter_latam/venv/bin/python -c "from api.main import app; print('OK')"
```

### 2. Reiniciar servicio
```bash
systemctl restart smarter-food
sleep 2
systemctl is-active smarter-food  # debe decir "active"
```

### 3. Health check
```bash
curl -s http://localhost:8002/health | python3 -m json.tool
```

### 4. Test validación
```bash
curl -s -X POST http://localhost:8002/api/validar \
  -H "Content-Type: application/json" \
  -d '{"id_objeto":"TEST","producto":"Test","precio":5500}' | python3 -m json.tool
```

### 5. Verificar docs
```bash
curl -sI https://docs.smarterbot.cl/ | head -3
curl -sI https://docs.smarterbot.cl/api/ | head -3
```

## Rollback

```bash
# Si algo falla, revertir cambios en main.py y reiniciar
systemctl restart smarter-food
```

## Reglas Críticas

1. Código sin .md → inválido
2. Cambio en lógica → requiere doc update
3. Doc desactualizada → sistema incoherente
4. Deploy sin doc → FAIL
