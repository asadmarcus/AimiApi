# Push to GitHub - Authentication Guide

## The repo exists but you need to authenticate!

## Option 1: GitHub CLI (Easiest)

### Install GitHub CLI:
```bash
winget install GitHub.cli
```

### Login and Push:
```bash
# Login to GitHub
gh auth login

# Follow prompts:
# - Choose: GitHub.com
# - Choose: HTTPS
# - Authenticate with: Login with a web browser
# - Copy the code and paste in browser

# Then push
git push -u origin main
```

## Option 2: Personal Access Token

### Create Token:
1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Name it: "LMArena Bridge"
4. Select scopes: ✅ **repo** (all repo permissions)
5. Click "Generate token"
6. **COPY THE TOKEN** (you won't see it again!)

### Push with Token:
```bash
# When prompted for password, use the token instead
git push -u origin main

# Username: jeroa201
# Password: [PASTE YOUR TOKEN HERE]
```

## Option 3: SSH Key (Most Secure)

### Generate SSH Key:
```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
# Press Enter for all prompts
```

### Add to GitHub:
```bash
# Copy your public key
type %USERPROFILE%\.ssh\id_ed25519.pub

# Go to: https://github.com/settings/keys
# Click "New SSH key"
# Paste your key
```

### Change Remote to SSH:
```bash
git remote remove origin
git remote add origin git@github.com:jeroa201/AimiLLMapi.git
git push -u origin main
```

## Quick Fix: Use GitHub Desktop

1. **Download:** https://desktop.github.com/
2. **Install and login** to GitHub
3. **File → Add Local Repository**
4. **Select your folder:** `C:\Users\asad\Downloads\LMArenaBridge-main`
5. **Click "Publish repository"**
6. **Choose:** jeroa201/AimiLLMapi
7. **Done!**

## Recommended: GitHub CLI

This is the easiest method:

```bash
# 1. Install
winget install GitHub.cli

# 2. Login (opens browser)
gh auth login

# 3. Push
git push -u origin main
```

## After Successful Push

Once pushed, go to Railway:
1. https://railway.app
2. Sign up with GitHub
3. Deploy from repo: jeroa201/AimiLLMapi
4. Get your URL!

Let me know which method you want to use!
