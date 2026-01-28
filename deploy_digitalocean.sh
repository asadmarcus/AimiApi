#!/bin/bash

# DigitalOcean Deployment Script for LMArena Bridge
# This script sets up the API on a fresh Ubuntu 22.04/24.04 droplet

set -e

echo "============================================"
echo "🚀 LMArena Bridge - DigitalOcean Deployment"
echo "============================================"
echo ""

# Update system
echo "📦 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Docker
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "✅ Docker installed"
else
    echo "✅ Docker already installed"
fi

# Install Docker Compose
echo "🐳 Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose installed"
else
    echo "✅ Docker Compose already installed"
fi

# Clone repository
echo "📥 Cloning repository..."
if [ -d "AimiApi" ]; then
    echo "⚠️  Directory exists, pulling latest changes..."
    cd AimiApi
    git pull
else
    git clone https://github.com/asadmarcus/AimiApi.git
    cd AimiApi
fi

# Build and start containers
echo "🏗️  Building Docker image..."
sudo docker-compose down 2>/dev/null || true
sudo docker-compose build --no-cache

echo "🚀 Starting containers..."
sudo docker-compose up -d

echo ""
echo "============================================"
echo "✅ Deployment Complete!"
echo "============================================"
echo ""
echo "📍 Your API is now running at:"
echo "   http://$(curl -s ifconfig.me):8000"
echo ""
echo "📚 API Endpoints:"
echo "   • Models: http://$(curl -s ifconfig.me):8000/api/v1/models"
echo "   • Chat: http://$(curl -s ifconfig.me):8000/api/v1/chat/completions"
echo "   • Dashboard: http://$(curl -s ifconfig.me):8000/dashboard"
echo ""
echo "🔐 Your API Key: sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb"
echo ""
echo "📊 Useful commands:"
echo "   • View logs: sudo docker-compose logs -f"
echo "   • Restart: sudo docker-compose restart"
echo "   • Stop: sudo docker-compose down"
echo "   • Update: git pull && sudo docker-compose up -d --build"
echo ""
echo "⚠️  Note: If you just installed Docker, you may need to log out and back in"
echo "   or run: newgrp docker"
echo ""
