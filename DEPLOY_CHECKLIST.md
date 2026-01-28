# Railway Deployment Checklist

## Before You Deploy

### ✅ 1. Create Alternate GitHub Account
- [ ] New email address
- [ ] New GitHub account
- [ ] Verify email

### ✅ 2. Prepare Your Code

- [ ] Set headless mode in `config.json`:
  ```json
  {
    "camoufox_fetch_headless": true
  }
  ```

- [ ] Change default password in `config.json`:
  ```json
  {
    "password": "YOUR_STRONG_PASSWORD"
  }
  ```

- [ ] Make sure `.gitignore` is in place (already created)

- [ ] Make sure `railway.json` is in place (already created)

### ✅ 3. Push to GitHub

```bash
# Initialize git
git init
git add .
git commit -m "Initial commit"

# Create NEW PRIVATE repo on GitHub with your alt account
# Then:
git remote add origin https://github.com/YOUR_ALT_ACCOUNT/lmarena-bridge.git
git branch -M main
git push -u origin main
```

### ✅ 4. Deploy to Railway

- [ ] Go to https://railway.app
- [ ] Sign up with alternate GitHub account
- [ ] Click "New Project"
- [ ] Select "Deploy from GitHub repo"
- [ ] Choose your repository
- [ ] Wait for deployment (2-3 minutes)

### ✅ 5. Get Your URL

- [ ] Go to "Settings" tab in Railway
- [ ] Click "Generate Domain"
- [ ] Copy your URL: `https://xxxxx.up.railway.app`

### ✅ 6. Test Your API

```bash
# Test models endpoint
curl https://YOUR_URL.up.railway.app/api/v1/models

# Test chat
curl -X POST https://YOUR_URL.up.railway.app/api/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb" \
  -d '{"model":"gemini-3-flash","messages":[{"role":"user","content":"Hi"}]}'
```

### ✅ 7. Access Dashboard

- [ ] Go to: `https://YOUR_URL.up.railway.app/dashboard`
- [ ] Login with your password
- [ ] Verify everything works

## After Deployment

### Monitor Your App

- [ ] Check Railway logs for errors
- [ ] Monitor free tier usage (500 hours/month)
- [ ] Set up uptime monitoring (optional)

### Backup Plan

- [ ] Save your Railway URL
- [ ] Keep config.json backed up locally
- [ ] Have Render.com account ready as backup
- [ ] Keep VPS option in mind if needed

### Security

- [ ] Don't share your Railway URL publicly
- [ ] Use strong API keys
- [ ] Monitor usage stats in dashboard
- [ ] Rotate API keys if compromised

## If Something Goes Wrong

### App Won't Start
1. Check Railway logs
2. Verify `requirements.txt` is complete
3. Check Python version compatibility

### Can't Access API
1. Make sure domain is generated
2. Check if app is running in Railway dashboard
3. Verify firewall/network settings

### Gets Shut Down
1. Don't panic!
2. Deploy to Render.com (same process)
3. Or use VPS (Hetzner $4/month)

## Quick Commands

### View Railway Logs
```bash
# Install Railway CLI (optional)
npm i -g @railway/cli

# Login
railway login

# View logs
railway logs
```

### Update Deployment
```bash
# Make changes locally
git add .
git commit -m "Update"
git push

# Railway auto-deploys!
```

### Rollback
In Railway dashboard:
- Go to "Deployments"
- Click previous deployment
- Click "Redeploy"

## Your URLs

After deployment, save these:

```
API Base:    https://YOUR_APP.up.railway.app/api/v1
Dashboard:   https://YOUR_APP.up.railway.app/dashboard
Models:      https://YOUR_APP.up.railway.app/api/v1/models
Health:      https://YOUR_APP.up.railway.app/api/v1/models
```

## Use in OpenWebUI

```
API Base URL: https://YOUR_APP.up.railway.app/api/v1
API Key:      sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb
```

## Summary

✅ Alternate account: Protects your main account
✅ Private repo: Keeps code hidden
✅ Railway: Easy deployment
✅ Free tier: 500 hours/month
✅ Backup plan: Render/VPS ready

Good luck! 🚀
