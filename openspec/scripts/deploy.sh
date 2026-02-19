#!/bin/bash

set -e

echo "🚀 OpenSpec Deployment Script"
echo "=============================="

cd /root/Smarter-SPECS/openspec

# Check if .env exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cat > .env << 'ENVEOF'
API_URL=https://api.smarterbot.cl
SERCOTEC_API=https://apiautenticador.sercotec.cl
NODE_ENV=production
PUBLIC_SITE_URL=https://openspec.smarterbot.cl
ENVEOF
    echo "✅ .env created"
fi

# Build Docker image
echo "🔨 Building Docker image..."
docker build -t smarteros-openspec .

# Stop old container
echo "🛑 Stopping old container..."
docker stop smarteros-openspec 2>/dev/null || true
docker rm smarteros-openspec 2>/dev/null || true

# Run new container on smarteros network
echo "🏃 Starting new container..."
docker run -d \
  --network smarteros \
  --name smarteros-openspec \
  --restart unless-stopped \
  -p 4321:4321 \
  -e PORT=4321 \
  smarteros-openspec

echo ""
echo "✅ OpenSpec deployed successfully!"
echo ""
echo "📊 Verify deployment:"
echo "   docker ps | grep openspec"
echo "   docker logs smarteros-openspec -f"
echo ""
echo "🌐 Test locally:"
echo "   curl http://localhost:4321"
echo ""
echo "🔗 Public URL: https://openspec.smarterbot.cl"
