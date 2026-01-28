# Deploying LMArena Bridge as a Real API

## Overview

You can deploy this bridge to run 24/7 without keeping your PC on. Here are your options:

## Option 1: VPS/Cloud Server (Recommended)

Deploy to a Virtual Private Server that runs 24/7.

### Best Providers:

1. **DigitalOcean** ($6-12/month)
   - Easy setup
   - Good performance
   - 1-click apps

2. **Vultr** ($6-12/month)
   - Similar to DigitalOcean
   - Multiple locations

3. **Hetzner** ($4-8/month)
   - Cheapest option
   - Good performance
   - EU-based

4. **AWS EC2** (Free tier available)
   - 12 months free
   - t2.micro instance
   - More complex setup

5. **Google Cloud** (Free tier available)
   - $300 credit for 90 days
   - e2-micro free forever
   - Good for testing

### Requirements:
- **RAM:** 2GB minimum (4GB recommended)
- **CPU:** 1-2 cores
- **Storage:** 20GB
- **OS:** Ubuntu 22.04 LTS

### Setup Steps:

1. **Create a VPS instance**
2. **SSH into your server:**
   ```bash
   ssh root@YOUR_SERVER_IP
   ```

3. **Install dependencies:**
   ```bash
   # Update system
   apt update && apt upgrade -y
   
   # Install Python 3.11
   apt install python3.11 python3.11-venv python3-pip -y
   
   # Install Playwright dependencies
   apt install -y \
     libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
     libcups2 libdrm2 libxkbcommon0 libxcomposite1 \
     libxdamage1 libxfixes3 libxrandr2 libgbm1 \
     libpango-1.0-0 libcairo2 libasound2
   ```

4. **Upload your bridge:**
   ```bash
   # On your PC, zip the project
   # Then upload to server
   scp LMArenaBridge.zip root@YOUR_SERVER_IP:/root/
   
   # On server, unzip
   cd /root
   unzip LMArenaBridge.zip
   cd LMArenaBridge-main
   ```

5. **Install Python packages:**
   ```bash
   python3.11 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

6. **Run as a service** (see systemd section below)

## Option 2: Docker Container (Advanced)

Run in a Docker container for easy deployment.

### Dockerfile:

```dockerfile
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 \
    libxdamage1 libxfixes3 libxrandr2 libgbm1 \
    libpango-1.0-0 libcairo2 libasound2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Expose port
EXPOSE 8000

# Run the application
CMD ["python", "src/main.py"]
```

### docker-compose.yml:

```yaml
version: '3.8'

services:
  lmarena-bridge:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - ./config.json:/app/config.json
      - ./models.json:/app/models.json
      - ./chrome_grecaptcha:/app/chrome_grecaptcha
    restart: unless-stopped
    environment:
      - PYTHONUNBUFFERED=1
```

### Deploy with Docker:

```bash
# Build and run
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

## Option 3: Railway.app (Easiest - Free Tier)

Deploy with one click, no server management needed.

### Steps:

1. **Create account** at railway.app
2. **Connect GitHub** (push your code to GitHub first)
3. **Deploy from GitHub:**
   - Click "New Project"
   - Select your repository
   - Railway auto-detects Python
4. **Set environment variables** (if needed)
5. **Get your URL:** `https://your-app.railway.app`

**Pros:**
- ✅ Free tier: 500 hours/month
- ✅ Automatic HTTPS
- ✅ Easy deployment
- ✅ Auto-restarts

**Cons:**
- ⚠️ Headless browser may have issues
- ⚠️ Limited to 8GB RAM on free tier

## Option 4: Render.com (Free Tier)

Similar to Railway, easy deployment.

### Steps:

1. **Create account** at render.com
2. **New Web Service**
3. **Connect GitHub repository**
4. **Configure:**
   - Build Command: `pip install -r requirements.txt`
   - Start Command: `python src/main.py`
5. **Deploy**

**Free tier:**
- ✅ 750 hours/month
- ✅ Automatic HTTPS
- ⚠️ Spins down after 15 min inactivity

## Option 5: Fly.io (Free Tier)

Good for Docker deployments.

### Steps:

1. **Install flyctl:**
   ```bash
   curl -L https://fly.io/install.sh | sh
   ```

2. **Login:**
   ```bash
   flyctl auth login
   ```

3. **Launch app:**
   ```bash
   flyctl launch
   ```

4. **Deploy:**
   ```bash
   flyctl deploy
   ```

**Free tier:**
- ✅ 3 shared-cpu VMs
- ✅ 3GB storage
- ✅ 160GB bandwidth

## Running as a System Service (Linux)

### Create systemd service:

```bash
sudo nano /etc/systemd/system/lmarena-bridge.service
```

### Service file content:

```ini
[Unit]
Description=LMArena Bridge API
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/LMArenaBridge-main
Environment="PATH=/root/LMArenaBridge-main/venv/bin"
ExecStart=/root/LMArenaBridge-main/venv/bin/python src/main.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable lmarena-bridge
sudo systemctl start lmarena-bridge
sudo systemctl status lmarena-bridge
```

### View logs:

```bash
sudo journalctl -u lmarena-bridge -f
```

## Nginx Reverse Proxy (Optional)

Add HTTPS and custom domain.

### Install Nginx:

```bash
apt install nginx certbot python3-certbot-nginx -y
```

### Configure Nginx:

```bash
sudo nano /etc/nginx/sites-available/lmarena-bridge
```

### Nginx config:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # For streaming responses
        proxy_buffering off;
        proxy_cache off;
        proxy_read_timeout 300s;
    }
}
```

### Enable site:

```bash
sudo ln -s /etc/nginx/sites-available/lmarena-bridge /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### Add HTTPS:

```bash
sudo certbot --nginx -d your-domain.com
```

## Security Considerations

### 1. Firewall Setup:

```bash
# Allow SSH
ufw allow 22/tcp

# Allow HTTP/HTTPS
ufw allow 80/tcp
ufw allow 443/tcp

# Enable firewall
ufw enable
```

### 2. Change Default Password:

Edit `config.json`:
```json
{
  "password": "YOUR_STRONG_PASSWORD_HERE"
}
```

### 3. Use Strong API Keys:

Generate new keys in the dashboard with strong random values.

### 4. Rate Limiting:

Already built-in! Configure in dashboard:
- Set appropriate RPM limits
- Monitor usage stats

## Monitoring

### 1. Check if service is running:

```bash
systemctl status lmarena-bridge
```

### 2. View logs:

```bash
journalctl -u lmarena-bridge -f
```

### 3. Monitor resources:

```bash
htop
```

### 4. Check API health:

```bash
curl http://localhost:8000/api/v1/models
```

## Cost Comparison

| Provider | Cost/Month | Free Tier | Best For |
|----------|-----------|-----------|----------|
| **Hetzner** | $4-8 | No | Budget hosting |
| **DigitalOcean** | $6-12 | $200 credit | Easy setup |
| **Vultr** | $6-12 | $100 credit | Reliability |
| **AWS EC2** | $0-10 | 12 months | Enterprise |
| **Railway** | $0-5 | 500 hrs | Quick deploy |
| **Render** | $0-7 | 750 hrs | Simple apps |
| **Fly.io** | $0-5 | 3 VMs | Docker apps |

## Recommended Setup

### For Production:
1. **VPS:** DigitalOcean or Hetzner ($6-8/month)
2. **OS:** Ubuntu 22.04 LTS
3. **Service:** systemd for auto-restart
4. **Proxy:** Nginx with HTTPS
5. **Domain:** Custom domain with SSL
6. **Monitoring:** systemd logs + uptime monitoring

### For Testing:
1. **Platform:** Railway.app or Render.com
2. **Cost:** Free tier
3. **Setup:** 5 minutes
4. **HTTPS:** Automatic

## Quick Start: DigitalOcean Deployment

I can create a complete deployment script for you. Would you like:

1. **One-click deployment script** for DigitalOcean?
2. **Docker setup** for any VPS?
3. **Railway/Render deployment** guide?

Let me know which option you prefer!
