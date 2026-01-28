# DigitalOcean Deployment Guide

## Prerequisites
- DigitalOcean account
- SSH key added to your account

## Step 1: Create a Droplet

1. Go to [DigitalOcean](https://cloud.digitalocean.com/)
2. Click **Create** → **Droplets**
3. Choose configuration:
   - **Image:** Ubuntu 24.04 LTS
   - **Plan:** Basic
   - **CPU:** Regular (2 GB RAM / 1 CPU) - $12/month
     - Or 4 GB RAM / 2 CPU for better performance - $24/month
   - **Datacenter:** Choose closest to your users
   - **Authentication:** SSH Key (recommended) or Password
   - **Hostname:** `lmarena-api` (or your choice)
4. Click **Create Droplet**
5. Wait 1-2 minutes for droplet to be ready
6. Copy the droplet's IP address

## Step 2: Connect to Your Droplet

```bash
ssh root@YOUR_DROPLET_IP
```

Replace `YOUR_DROPLET_IP` with your actual droplet IP.

## Step 3: Run Deployment Script

Copy and paste this one-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/asadmarcus/AimiApi/main/deploy_digitalocean.sh | bash
```

Or manually:

```bash
# Download the script
wget https://raw.githubusercontent.com/asadmarcus/AimiApi/main/deploy_digitalocean.sh

# Make it executable
chmod +x deploy_digitalocean.sh

# Run it
./deploy_digitalocean.sh
```

The script will:
- ✅ Update system packages
- ✅ Install Docker and Docker Compose
- ✅ Clone the repository
- ✅ Build and start the API

**This takes 5-10 minutes** (mostly downloading and building).

## Step 4: Test Your API

Once deployment completes, test it:

```bash
# Check if it's running
curl http://YOUR_DROPLET_IP:8000/api/v1/models \
  -H "Authorization: Bearer sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb"

# Test chat completion
curl http://YOUR_DROPLET_IP:8000/api/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb" \
  -d '{
    "model": "gemini-3-flash",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## Step 5: Set Up Domain (Optional)

If you have a domain:

1. Add an A record pointing to your droplet IP
2. Install Nginx as reverse proxy:

```bash
sudo apt install nginx -y

# Create Nginx config
sudo nano /etc/nginx/sites-available/lmarena-api
```

Add this configuration:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

Enable and restart:

```bash
sudo ln -s /etc/nginx/sites-available/lmarena-api /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

3. Install SSL with Let's Encrypt:

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your-domain.com
```

## Useful Commands

### View Logs
```bash
cd AimiApi
sudo docker-compose logs -f
```

### Restart Service
```bash
cd AimiApi
sudo docker-compose restart
```

### Stop Service
```bash
cd AimiApi
sudo docker-compose down
```

### Update to Latest Version
```bash
cd AimiApi
git pull
sudo docker-compose up -d --build
```

### Check Status
```bash
cd AimiApi
sudo docker-compose ps
```

## Firewall Setup (Recommended)

```bash
# Allow SSH
sudo ufw allow 22/tcp

# Allow HTTP/HTTPS (if using domain)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow API port (if accessing directly by IP)
sudo ufw allow 8000/tcp

# Enable firewall
sudo ufw enable
```

## Troubleshooting

### Container won't start
```bash
cd AimiApi
sudo docker-compose logs
```

### Out of memory
Upgrade to a larger droplet or add swap:
```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### Port already in use
```bash
sudo lsof -i :8000
# Kill the process using the port
sudo kill -9 <PID>
```

## Cost Estimate

- **Basic Droplet (2GB RAM):** $12/month
- **Better Performance (4GB RAM):** $24/month
- **Domain (optional):** ~$10-15/year
- **Total:** $12-24/month

## Security Notes

1. Change the default API key in `config.json`
2. Use SSH keys instead of passwords
3. Enable UFW firewall
4. Keep system updated: `sudo apt update && sudo apt upgrade`
5. Consider using a domain with SSL instead of raw IP

## Your API Endpoints

Once deployed, your API will be available at:

- **Base URL:** `http://YOUR_DROPLET_IP:8000`
- **Models:** `http://YOUR_DROPLET_IP:8000/api/v1/models`
- **Chat:** `http://YOUR_DROPLET_IP:8000/api/v1/chat/completions`
- **Dashboard:** `http://YOUR_DROPLET_IP:8000/dashboard`

**API Key:** `sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb`
