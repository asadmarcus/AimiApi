# 🚀 Ready to Deploy!

## ✅ What I Did For You:

1. ✅ **Set headless mode** to `true` (Railway needs this)
2. ✅ **Initialized git repository**
3. ✅ **Added all files** to git
4. ✅ **Created initial commit**
5. ✅ **Created deployment configs** (railway.json, Dockerfile, etc.)

## 📋 Next Steps (5 Minutes):

### Step 1: Create GitHub Repository

1. **Go to:** https://github.com/new
2. **Use your alternate account**
3. **Repository name:** `lmarena-bridge` (or any name)
4. **Make it PRIVATE** ✅ (important!)
5. **Don't initialize** with README (we already have files)
6. **Click:** "Create repository"

### Step 2: Push Your Code

GitHub will show you commands. Copy and run these in your terminal:

```bash
# Add your GitHub repo as remote
git remote add origin https://github.com/YOUR_ALT_USERNAME/lmarena-bridge.git

# Push to GitHub
git branch -M main
git push -u origin main
```

**Example:**
```bash
git remote add origin https://github.com/john-alt/lmarena-bridge.git
git branch -M main
git push -u origin main
```

### Step 3: Deploy to Railway

1. **Go to:** https://railway.app
2. **Sign up** with your alternate GitHub account
3. **Click:** "New Project"
4. **Select:** "Deploy from GitHub repo"
5. **Choose:** Your `lmarena-bridge` repository
6. **Wait:** 2-3 minutes for deployment

### Step 4: Get Your URL

1. In Railway dashboard, click your project
2. Go to **"Settings"** tab
3. Scroll to **"Domains"**
4. Click **"Generate Domain"**
5. Copy your URL: `https://xxxxx.up.railway.app`

### Step 5: Test Your API

```bash
# Replace YOUR_URL with your Railway URL
curl https://YOUR_URL.up.railway.app/api/v1/models
```

If you see a list of models, it's working! 🎉

### Step 6: Access Dashboard

```
https://YOUR_URL.up.railway.app/dashboard
```

Login with password: `admin`

## 🔧 Important Settings

### Change Password (Recommended)

After deployment, edit `config.json` on GitHub:
1. Go to your repo
2. Click `config.json`
3. Click edit (pencil icon)
4. Change `"password": "admin"` to something strong
5. Commit changes
6. Railway auto-deploys!

### Monitor Your App

In Railway dashboard:
- **Deployments:** See deployment history
- **Logs:** View real-time logs
- **Metrics:** Check CPU/RAM usage
- **Settings:** Configure domains, environment variables

## 📱 Use Your API

### In OpenWebUI:
```
API Base URL: https://YOUR_URL.up.railway.app/api/v1
API Key: sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb
```

### Direct API Call:
```bash
curl -X POST https://YOUR_URL.up.railway.app/api/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb" \
  -d '{
    "model": "gemini-3-flash",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## ⚠️ Troubleshooting

### Can't push to GitHub?
```bash
# Make sure you're logged in
git config --global user.name "Your Name"
git config --global user.email "your-alt-email@example.com"

# Try again
git push -u origin main
```

### Railway deployment failed?
1. Check logs in Railway dashboard
2. Make sure `requirements.txt` is complete
3. Verify `railway.json` is present

### App not responding?
1. Check Railway logs for errors
2. Make sure app is running (not sleeping)
3. Verify domain is generated

## 🎯 Quick Commands

### View git status:
```bash
git status
```

### Make changes and update:
```bash
git add .
git commit -m "Update config"
git push
```

Railway will auto-deploy your changes!

## 📊 Free Tier Limits

Railway free tier:
- ✅ 500 hours/month
- ✅ 512MB RAM
- ✅ 1GB disk
- ✅ Shared CPU

Your app sleeps after 5 min inactivity (saves hours).

## 🆘 Need Help?

Check these files:
- **RAILWAY_DEPLOY.md** - Detailed Railway guide
- **DEPLOY_CHECKLIST.md** - Step-by-step checklist
- **DEPLOYMENT_GUIDE.md** - All deployment options

## 🎉 You're Almost There!

Just 3 commands away from having your API live:

```bash
git remote add origin https://github.com/YOUR_ALT_USERNAME/lmarena-bridge.git
git branch -M main
git push -u origin main
```

Then deploy on Railway.app!

Good luck! 🚀
