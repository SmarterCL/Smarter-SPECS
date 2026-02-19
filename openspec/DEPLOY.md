# 🚀 OpenSpec Deployment Guide

## Quick Deploy to Vercel

1. **Connect Repository**
   ```bash
   # Go to vercel.com and import:
   https://github.com/SmarterCL/Smarter-SPECS
   
   # Set root directory to: openspec
   ```

2. **Deploy Commands**
   ```bash
   # Install
   npm install
   
   # Build
   npm run build
   
   # Preview
   npm run preview
   ```

3. **Environment Variables**
   ```
   API_URL=https://api.smarterbot.cl
   SERCOTEC_API=https://apiautenticador.sercotec.cl
   NODE_ENV=production
   ```

## Docker Deploy (VPS)

```bash
cd /root/Smarter-SPECS/openspec

# Build
docker build -t smarteros-openspec .

# Run
docker run -d --name smarteros-openspec -p 3000:3000 \
  --restart unless-stopped \
  smarteros-openspec
```

## Caddy Configuration

Add to `/etc/caddy/Caddyfile`:

```caddy
openspec.smarterbot.cl {
    reverse_proxy smarteros-openspec:3000
    encode gzip
    log {
        output file /var/log/caddy/openspec-access.log
    }
}

erp.smarterbot.cl {
    reverse_proxy odoo-tienda:8069
    encode gzip
    log {
        output file /var/log/caddy/erp-access.log
    }
}
```

Then reload:
```bash
docker exec caddy-proxy caddy reload --config /etc/caddy/Caddyfile
```

## Manual Git Push

```bash
# Configure SSH if not already done
git remote set-url origin git@github.com:SmarterCL/Smarter-SPECS.git

# Push
git push origin main
```

## Verification

After deploy, verify:

```bash
# Test OpenSpec
curl -I https://openspec.smarterbot.cl

# Should return HTTP/2 200

# Test ERP redirect
curl -I https://erp.smarterbot.cl

# Should show Odoo login
```

## Architecture

```
openspec.smarterbot.cl → Astro Frontend (Public)
                            ↓
                    api.smarterbot.cl (FastAPI)
                            ↓
                    Odoo + Supabase + Sercotec

erp.smarterbot.cl → Odoo Direct (Private/Internal)
```
