# Token Rotation & Rate Limiting Guide

## Good News! 🎉

Your LMArena Bridge **already has built-in token rotation and rate limiting**! Here's what's already working:

## Current Features

### 1. **Round-Robin Token Rotation** ✅
The bridge automatically rotates through multiple auth tokens using a round-robin algorithm:
- Distributes requests across all available tokens
- Automatically excludes expired tokens
- Falls back to next token if one fails
- Reduces risk of rate limiting on any single account

### 2. **Rate Limiting Per API Key** ✅
Each API key has its own rate limit (default: 60 RPM):
```json
{
  "api_keys": [
    {
      "name": "aimichat",
      "key": "sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb",
      "rpm": 60  // ← Requests per minute limit
    }
  ]
}
```

### 3. **Automatic Retry with Backoff** ✅
When rate limited (429 errors):
- Respects `Retry-After` headers from LMArena
- Exponential backoff (5s, 10s, 20s, etc.)
- Automatically rotates to next token on rate limit
- Retries up to 3 times before failing

### 4. **Token Health Monitoring** ✅
- Automatically detects expired tokens
- Refreshes base64 session tokens when possible
- Excludes failed tokens from rotation
- Falls back to browser-captured tokens

## How to Add More Tokens (Reduce Ban Risk)

### Method 1: Via Dashboard (Recommended)

1. **Get more LMArena accounts:**
   - Create multiple Google accounts
   - Sign in to lmarena.ai with each account
   - Get the `arena-auth-prod-v1` cookie from each

2. **Add tokens via dashboard:**
   - Go to http://localhost:8000/dashboard
   - Click "Refresh Tokens" button
   - Or manually add to the "Auth Tokens" section

### Method 2: Manual Config Edit

Edit `config.json` and add multiple tokens:

```json
{
  "auth_tokens": [
    "base64-eyJhY2Nlc3NfdG9rZW4iOi...",  // Account 1
    "base64-eyJhY2Nlc3NfdG9rZW4iOi...",  // Account 2
    "base64-eyJhY2Nlc3NfdG9rZW4iOi...",  // Account 3
    "base64-eyJhY2Nlc3NfdG9rZW4iOi..."   // Account 4
  ]
}
```

### Method 3: Get Token from Browser

1. Open lmarena.ai in your browser
2. Press F12 (Developer Tools)
3. Go to Application → Cookies → https://lmarena.ai
4. Find `arena-auth-prod-v1` cookie
5. Copy the value (starts with `base64-`)
6. Add to `auth_tokens` array in config.json

## Current Configuration

You currently have **1 auth token** configured:
```json
{
  "auth_tokens": [
    "base64-eyJhY2Nlc3NfdG9rZW4iOi..."  // Your current token
  ]
}
```

## Recommended Setup to Avoid Bans

### Conservative (Low Risk)
- **3-5 accounts** with token rotation
- **30 RPM** per API key
- Total: ~90-150 requests/minute distributed

### Moderate (Medium Risk)
- **5-10 accounts** with token rotation
- **60 RPM** per API key
- Total: ~300-600 requests/minute distributed

### Aggressive (Higher Risk)
- **10+ accounts** with token rotation
- **100 RPM** per API key
- Total: 1000+ requests/minute distributed

## How Token Rotation Works

```
Request 1 → Token A → Success
Request 2 → Token B → Success
Request 3 → Token C → Success
Request 4 → Token A → Rate Limited (429)
Request 4 → Token B → Success (automatic retry)
Request 5 → Token C → Success
...
```

## Monitoring Token Health

Check the server logs for:
- `🔄 Rotating to next token` - Token rotation happening
- `⏱️ Rate limit with token xxx...` - Token hit rate limit
- `✅ Token refreshed` - Expired token auto-refreshed
- `❌ Token expired` - Token needs replacement

## Best Practices

### 1. **Use Multiple Accounts**
- Create 3-5 Google accounts minimum
- Sign in to lmarena.ai with each
- Extract and add all tokens to config

### 2. **Set Conservative Rate Limits**
- Start with 30-60 RPM per API key
- Monitor for 429 errors
- Gradually increase if stable

### 3. **Monitor Usage**
- Check dashboard at http://localhost:8000/dashboard
- Watch for "Usage Stats" section
- Look for patterns of rate limiting

### 4. **Rotate Tokens Regularly**
- Tokens expire after ~1 hour
- Bridge auto-refreshes base64 tokens
- Manually refresh if seeing auth errors

### 5. **Use Different User Agents** (Optional)
The bridge already rotates user agents automatically, but you can customize:
```json
{
  "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ..."
}
```

## Testing Token Rotation

Run multiple requests quickly to see rotation in action:

```bash
# Run 10 requests rapidly
for i in {1..10}; do
  curl -X POST http://localhost:8000/api/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer sk-lmab-562ba111-ab4f-455c-82f0-1294220566bb" \
    -d '{"model":"gemini-3-flash","messages":[{"role":"user","content":"Test '$i'"}]}' &
done
```

Watch the server logs - you'll see tokens rotating!

## What Happens if You Get Banned?

If an account gets banned:
1. ✅ Bridge automatically excludes that token
2. ✅ Rotates to next available token
3. ✅ Continues serving requests
4. ⚠️ You'll see errors for that specific token in logs

**Solution:** Remove the banned token from `auth_tokens` and add a new one.

## Current Risk Level

With **1 token** and **60 RPM**:
- ⚠️ **Medium Risk** - All requests use same account
- 🔴 **Single Point of Failure** - If banned, bridge stops working

**Recommendation:** Add 2-4 more tokens to distribute load and reduce ban risk.

## Quick Setup: Add More Tokens Now

1. **Create 2-3 more Google accounts**
2. **Sign in to lmarena.ai with each**
3. **Get cookies** (F12 → Application → Cookies → `arena-auth-prod-v1`)
4. **Add to config.json:**
   ```json
   {
     "auth_tokens": [
       "base64-YOUR_CURRENT_TOKEN",
       "base64-NEW_TOKEN_FROM_ACCOUNT_2",
       "base64-NEW_TOKEN_FROM_ACCOUNT_3"
     ]
   }
   ```
5. **Restart server:** `python src/main.py`
6. **Test:** Requests will now rotate across all 3 accounts!

## Summary

✅ Token rotation is **already working**
✅ Rate limiting is **already configured**
✅ Automatic retries are **already implemented**
⚠️ You just need to **add more tokens** to reduce ban risk

The bridge is production-ready - just add more accounts for better distribution!
