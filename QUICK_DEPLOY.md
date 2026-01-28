# Quick Deployment Guide

## Choose Your Deployment Method

### 🚀 Option 1: Railway.app (Easiest - 5 minutes)

**Best for:** Quick testing, no server management

1. **Push to GitHub:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin YOUR_GITHUB_REPO
   git push -u origin main
   ```

2. **Deploy to Railway:**
   - Go to https://railway.app
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose your repository
   - Railway auto-detects and deploys!

3. **Get your URL:**
   - Railway gives you: `https://your-app.railway.app`
   - Access API: `https://your-app.railway.app/api/v1/chat/completions`

**Cost:** Free (500 hours/month)

---

### 🐳 Option 2: Docker (Any VPS - 10 minutes)

**Best for:** Full control, any cloud provider

1. **Get a VPS:**
   - DigitalOcean: $6/month
   - Hetzner: $4/month
   - Vultr: $6/month

2. **SSH into server:**
   ```bash
   ssh root@YOUR_SERVER_IP
   ```

3. **Install Docker:**
   ```bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   sh get-docker.sh
   ```

4. **Upload your files:**
   ```bash
   # On your PC
   scp -r LMArenaBridge-main root@YOUR_SERVER_IP:/root/
   ```

5. **Deploy:**
   ```bash
   # On server
   cd /root/LMArenaBridge-main
   docker-compose up -d
   ```

6. **Access your API:**
   ```
   http://YOUR_SERVER_IP:8000
   ```

**Cost:** $4-12/month

---

### 💻 Option 3: VPS with systemd (15 minutes)

**Best for:** Production, maximum control

1. **Get Ubuntu 22.04 VPS**

2. **Upload deployment script:**
   ```bash
   scp deploy_vps.sh root@YOUR_SERVER_IP:/root/
   ```

3. **Upload your files:**
   ```bash
   scp -r LMArenaBridge-main/* root@YOUR_SERVER_IP:/opt/lmarena-bridge/
   ```

4. **Run deployment:**
   ```bash
   ssh root@YOUR_SERVER_IP
   chmod +x /root/deploy_vps.sh
   /root/deploy_vps.sh
   ```

5. **Access your API:**
   ```
   http://YOUR_SERVER_IP:8000
   ```

**Cost:** $4-12/month

---

## After Deployment

### 1. Test Your API:

```bash
curl -X POST http://YOUR_URL/api/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb" \
  -d '{
    "model": "gemini-3-flash",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### 2. Access Dashboard:

```
http://YOUR_URL/dashboard
```

### 3. Change Default Password:

Edit `config.json`:
```json
{
  "password": "YOUR_STRONG_PASSWORD"
}
```

### 4. Use in OpenWebUI:

- **API Base URL:** `http://YOUR_URL/api/v1`
- **API Key:** `sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb`

---

## Monitoring

### Check if running:

**Railway:**
- View logs in Railway dashboard

**Docker:**
```bash
docker-compose logs -f
```

**systemd:**
```bash
systemctl status lmarena-bridge
journalctl -u lmarena-bridge -f
```

---

## Troubleshooting

### Service won't start:

```bash
# Check logs
journalctl -u lmarena-bridge -n 50

# Restart service
systemctl restart lmarena-bridge
```

### Docker issues:

```bash
# Rebuild
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# View logs
docker-compose logs -f
```

### Can't access from outside:

```bash
# Check firewall
ufw status

# Allow port
ufw allow 8000/tcp
```

---

## Recommended: DigitalOcean Setup

### Step-by-Step:

1. **Create account:** https://digitalocean.com
2. **Create Droplet:**
   - Image: Ubuntu 22.04 LTS
   - Plan: Basic ($6/month)
   - CPU: Regular (1 vCPU, 1GB RAM)
   - Datacenter: Closest to you
3. **Get IP address** from dashboard
4. **Follow Option 3** above (VPS with systemd)

### Total time: 15 minutes
### Cost: $6/month

---

## Need Help?

I can help you with:
1. Setting up on specific provider
2. Configuring custom domain
3. Adding HTTPS/SSL
4. Setting up monitoring
5. Optimizing performance

Just let me know which option you want to use!
