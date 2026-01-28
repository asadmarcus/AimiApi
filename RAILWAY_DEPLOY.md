# Railway.app Deployment Guide

## Quick Deploy (5 Minutes)

### Step 1: Prepare Your Code

1. **Create a new GitHub account** (or use alternate)
2. **Create a new repository** (private recommended)

### Step 2: Add Railway Config

Create `railway.json` in your project root:

```json
{
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "python src/main.py",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

### Step 3: Push to GitHub

```bash
# Initialize git
git init
git add .
git commit -m "Initial commit"

# Create repo on GitHub, then:
git remote add origin https://github.com/YOUR_ALT_ACCOUNT/lmarena-bridge.git
git branch -M main
git push -u origin main
```

### Step 4: Deploy to Railway

1. **Go to:** https://railway.app
2. **Sign up** with your alternate GitHub account
3. **Click:** "New Project"
4. **Select:** "Deploy from GitHub repo"
5. **Choose:** Your lmarena-bridge repository
6. **Wait:** Railway auto-detects Python and deploys!

### Step 5: Configure Environment (Optional)

In Railway dashboard:
- Click your project
- Go to "Variables" tab
- Add any environment variables if needed

### Step 6: Get Your URL

1. Go to "Settings" tab
2. Click "Generate Domain"
3. You'll get: `https://your-app-production.up.railway.app`

### Step 7: Test It

```bash
curl https://your-app-production.up.railway.app/api/v1/models
```

## Important Files for Railway

### 1. runtime.txt (Optional)
Specify Python version:
```
python-3.11.0
```

### 2. Procfile (Alternative to railway.json)
```
web: python src/main.py
```

### 3. .gitignore
Make sure to ignore:
```
__pycache__/
*.pyc
venv/
.env
config.json.backup*
chrome_grecaptcha/
*.log
```

## Configuration Tips

### 1. Set Headless Mode
Edit `config.json` before pushing:
```json
{
  "camoufox_fetch_headless": true
}
```

Railway doesn't have a display, so headless is required.

### 2. Keep Config Private
Add sensitive data as Railway environment variables instead of committing to GitHub.

### 3. Monitor Logs
In Railway dashboard:
- Click "Deployments"
- Click latest deployment
- View real-time logs

## Troubleshooting

### Build Fails
**Issue:** Missing dependencies

**Fix:** Make sure `requirements.txt` is complete:
```bash
pip freeze > requirements.txt
```

### Browser Issues
**Issue:** Camoufox can't start

**Fix:** Railway should auto-install browser dependencies, but if not, add to `railway.json`:
```json
{
  "build": {
    "builder": "NIXPACKS",
    "nixpacksPlan": {
      "phases": {
        "setup": {
          "nixPkgs": ["python311", "chromium"]
        }
      }
    }
  }
}
```

### Port Issues
**Issue:** Railway can't connect

**Fix:** Make sure your app binds to `0.0.0.0`:
```python
# In src/main.py, should already be:
uvicorn.run(app, host="0.0.0.0", port=8000)
```

### Memory Issues
**Issue:** App crashes due to memory

**Fix:** Railway free tier has 512MB RAM. Optimize:
- Use headless mode
- Reduce concurrent requests
- Clear browser cache regularly

## Free Tier Limits

Railway free tier includes:
- ✅ 500 hours/month execution time
- ✅ 512MB RAM
- ✅ 1GB disk
- ✅ Shared CPU

**Tips to stay within limits:**
- App sleeps after 5 min inactivity (good!)
- Only runs when receiving requests
- ~16 hours/day of active use

## Upgrade Options

If you hit limits:

### Hobby Plan ($5/month)
- 500 hours → Unlimited
- 512MB → 8GB RAM
- Better performance

### Pro Plan ($20/month)
- Everything in Hobby
- Priority support
- Custom domains

## Using Your Deployed API

### In OpenWebUI:
```
API Base URL: https://your-app-production.up.railway.app/api/v1
API Key: sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb
```

### Direct API Call:
```bash
curl -X POST https://your-app-production.up.railway.app/api/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb" \
  -d '{
    "model": "gemini-3-flash",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Dashboard:
```
https://your-app-production.up.railway.app/dashboard
```

## Security Tips

### 1. Use Private Repo
Make your GitHub repo private to hide your code.

### 2. Change Default Password
Before deploying, edit `config.json`:
```json
{
  "password": "STRONG_PASSWORD_HERE"
}
```

### 3. Rotate API Keys
Generate new API keys in the dashboard after deployment.

### 4. Monitor Usage
Check Railway dashboard regularly for:
- Unusual traffic
- High resource usage
- Error rates

## If Railway Shuts You Down

**Don't panic!** You have options:

### Plan B: Render.com
Same process, different platform:
1. Push same code to GitHub
2. Deploy to Render.com
3. Same ease of use

### Plan C: Fly.io
Slightly more technical:
```bash
flyctl launch
flyctl deploy
```

### Plan D: VPS
Ultimate fallback - can't be shut down:
- Hetzner: $4/month
- DigitalOcean: $6/month
- Use my `deploy_vps.sh` script

## Pro Tips

### 1. Use Multiple Accounts
- Deploy on Railway with alt account #1
- Deploy on Render with alt account #2
- If one gets shut down, switch to the other

### 2. Keep Backups
- Export your config.json regularly
- Keep models.json backed up
- Save your API keys

### 3. Monitor Health
Set up a cron job to ping your API:
```bash
# Every 5 minutes
*/5 * * * * curl https://your-app.railway.app/api/v1/models
```

This keeps it awake and alerts you if it's down.

## Summary

✅ **Easy:** 5 minute setup
✅ **Free:** 500 hours/month
✅ **Fast:** Auto-deploy from GitHub
✅ **HTTPS:** Included automatically
⚠️ **Risk:** Might get flagged (use alt account)
💡 **Backup:** Have Plan B ready (Render/VPS)

Good luck! 🚀
