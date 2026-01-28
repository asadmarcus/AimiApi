#!/bin/bash
# LMArena Bridge - VPS Deployment Script
# Run this on your Ubuntu 22.04 VPS

set -e

echo "============================================"
echo "LMArena Bridge - VPS Deployment"
echo "============================================"

# Update system
echo "📦 Updating system..."
apt update && apt upgrade -y

# Install Python 3.11
echo "🐍 Installing Python 3.11..."
apt install -y python3.11 python3.11-venv python3-pip git

# Install browser dependencies
echo "🌐 Installing browser dependencies..."
apt install -y \
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 \
    libxdamage1 libxfixes3 libxrandr2 libgbm1 \
    libpango-1.0-0 libcairo2 libasound2 \
    libxshmfence1 libglu1-mesa fonts-liberation

# Create app directory
echo "📁 Creating application directory..."
mkdir -p /opt/lmarena-bridge
cd /opt/lmarena-bridge

# Note: You need to upload your files here
echo "⚠️  Please upload your LMArena Bridge files to /opt/lmarena-bridge"
echo "   Use: scp -r LMArenaBridge-main/* root@YOUR_SERVER_IP:/opt/lmarena-bridge/"
echo ""
read -p "Press Enter after uploading files..."

# Create virtual environment
echo "🔧 Setting up virtual environment..."
python3.11 -m venv venv
source venv/bin/activate

# Install requirements
echo "📚 Installing Python packages..."
pip install --upgrade pip
pip install -r requirements.txt

# Create systemd service
echo "⚙️  Creating systemd service..."
cat > /etc/systemd/system/lmarena-bridge.service << 'EOF'
[Unit]
Description=LMArena Bridge API
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/lmarena-bridge
Environment="PATH=/opt/lmarena-bridge/venv/bin"
ExecStart=/opt/lmarena-bridge/venv/bin/python src/main.py
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload

# Enable and start service
echo "🚀 Starting service..."
systemctl enable lmarena-bridge
systemctl start lmarena-bridge

# Setup firewall
echo "🔒 Configuring firewall..."
ufw allow 22/tcp
ufw allow 8000/tcp
ufw --force enable

# Show status
echo ""
echo "============================================"
echo "✅ Deployment Complete!"
echo "============================================"
echo ""
echo "Service Status:"
systemctl status lmarena-bridge --no-pager
echo ""
echo "📊 Your API is running at:"
echo "   http://$(curl -s ifconfig.me):8000"
echo ""
echo "🔐 Dashboard:"
echo "   http://$(curl -s ifconfig.me):8000/dashboard"
echo ""
echo "📝 View logs:"
echo "   journalctl -u lmarena-bridge -f"
echo ""
echo "🔄 Restart service:"
echo "   systemctl restart lmarena-bridge"
echo ""
echo "⚠️  IMPORTANT: Change the default password in config.json!"
echo "============================================"
