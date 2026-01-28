# Using LMArena Bridge Without Login (Anonymous Mode)

## Yes, You Can Use It Without Logging In! ✅

The bridge supports **anonymous/provisional users** through LMArena's anonymous access feature.

## How It Works

LMArena allows anonymous users to:
- Use models without creating an account
- Get a `provisional_user_id` cookie
- Make requests with Cloudflare protection only

**Limitations:**
- May have stricter rate limits
- Some premium models might be restricted
- Less stable than authenticated access

## Setup for Anonymous Mode

### Option 1: Remove Auth Tokens (Quick)

Edit `config.json` and empty the auth_tokens array:

```json
{
  "auth_tokens": [],  // ← Empty = anonymous mode
  "provisional_user_id": "019c0501-1a9a-7b0f-97c1-ee216cafba75",
  "cf_clearance": "YOUR_CF_CLEARANCE_TOKEN"
}
```

### Option 2: Let Bridge Auto-Generate

1. **Delete your auth token:**
   ```json
   {
     "auth_tokens": []
   }
   ```

2. **Restart the server:**
   ```bash
   python src/main.py
   ```

3. **The bridge will automatically:**
   - Generate a `provisional_user_id`
   - Get Cloudflare clearance
   - Use anonymous access

## Current vs Anonymous Mode

### Your Current Setup (Authenticated)
```
✅ Logged in as: jeroa201@gmail.com
✅ Full access to all models
✅ Stable session (auto-refreshes)
⚠️  Single account = higher ban risk
```

### Anonymous Mode
```
✅ No login required
✅ Multiple provisional IDs possible
✅ Lower profile (harder to track)
⚠️  May have stricter limits
⚠️  Less stable (provisional IDs expire)
```

## Multiple Anonymous Sessions

You can rotate between multiple anonymous sessions:

```json
{
  "auth_tokens": [],
  "anonymous_sessions": [
    {
      "provisional_user_id": "019c0501-1a9a-7b0f-97c1-ee216cafba75",
      "cf_clearance": "TOKEN_1"
    },
    {
      "provisional_user_id": "019c0502-2b1b-8c1g-a8d2-ff327dbfcb86",
      "cf_clearance": "TOKEN_2"
    }
  ]
}
```

## How to Get Multiple Anonymous Sessions

### Method 1: Browser Profiles

1. **Open lmarena.ai in incognito/private mode**
2. **Don't log in** - just browse as anonymous
3. **Get cookies** (F12 → Application → Cookies):
   - `provisional_user_id`
   - `cf_clearance`
4. **Repeat in different browser profiles**

### Method 2: Let Bridge Generate

The bridge can automatically create anonymous sessions when it opens the browser for Cloudflare challenges.

## Testing Anonymous Mode

1. **Backup your current config:**
   ```bash
   copy config.json config.json.backup
   ```

2. **Remove auth tokens:**
   ```json
   {
     "auth_tokens": []
   }
   ```

3. **Restart server:**
   ```bash
   python src/main.py
   ```

4. **Test a request:**
   ```bash
   python test_chat.py
   ```

## Comparison: Authenticated vs Anonymous

| Feature | Authenticated | Anonymous |
|---------|--------------|-----------|
| **Setup** | Need Google account | No account needed |
| **Stability** | High (auto-refresh) | Medium (expires) |
| **Rate Limits** | Standard | May be stricter |
| **Model Access** | All models | Most models |
| **Ban Risk** | Medium (1 account) | Lower (disposable) |
| **Rotation** | Need multiple accounts | Easy to generate |

## Recommended Approach

### For Production (Stable)
**Use authenticated mode with multiple accounts:**
- 3-5 Google accounts
- Token rotation
- Auto-refresh
- Full model access

### For Testing/Development
**Use anonymous mode:**
- No account setup needed
- Quick to test
- Easy to rotate
- Lower profile

### Hybrid Approach (Best)
**Mix both:**
```json
{
  "auth_tokens": [
    "base64-ACCOUNT_1",  // Authenticated
    "base64-ACCOUNT_2"   // Authenticated
  ],
  "provisional_user_id": "019c0501...",  // Anonymous fallback
  "cf_clearance": "..."
}
```

The bridge will:
1. Try authenticated tokens first
2. Fall back to anonymous if tokens fail
3. Rotate between all available options

## Current Recommendation for You

Since you already have 1 authenticated account, I recommend:

**Option A: Add More Accounts (Best)**
- Keep your current account
- Add 2-3 more Google accounts
- Lower ban risk with rotation

**Option B: Go Anonymous (Simpler)**
- Remove auth tokens
- Use anonymous mode
- Generate multiple provisional IDs

**Option C: Hybrid (Safest)**
- Keep 1-2 authenticated accounts
- Add anonymous fallback
- Best of both worlds

## Quick Test: Try Anonymous Mode

Want to test it? Run this:

```bash
# Backup current config
copy config.json config.json.backup

# Edit config.json - set auth_tokens to []
# Then restart and test
python src/main.py
```

If it works well, you can stay anonymous. If you prefer stability, restore your authenticated token.

## Summary

✅ **Yes, you can use it without logging in**
✅ **Anonymous mode is supported**
✅ **Can rotate multiple anonymous sessions**
⚠️  **May have stricter limits than authenticated**
💡 **Hybrid approach (auth + anonymous) is best**

Your choice depends on:
- **Stability needed?** → Use authenticated
- **Quick testing?** → Use anonymous
- **Production use?** → Use hybrid with rotation
