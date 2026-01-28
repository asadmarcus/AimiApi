# LMArena Bridge Fixes Applied

## Issues Identified

Based on your error logs, there were two main issues:

1. **Permission Denied Error**: `SYNC_ERROR: Error: Permission denied to access object`
2. **Cloudflare Turnstile Loop**: Browser getting stuck trying to pass Cloudflare challenges

## Root Causes

### 1. Permission Denied Error
The code was using `main_world_eval=False` with Camoufox and trying to access `window.wrappedJSObject`, which is a Firefox-specific API for cross-context communication. This was causing permission errors when trying to execute reCAPTCHA.

**Location**: `src/main.py` line ~2215 in `get_recaptcha_v3_token()`

### 2. Cloudflare Detection Issues
The Cloudflare challenge detection was too simplistic - it only checked the page title, which wasn't reliable enough to detect when the challenge was actually passed.

**Location**: `src/main.py` line ~3810 in `get_initial_data()`

## Fixes Applied

### Fix 1: Changed Camoufox Execution Context
**Changed from:**
```python
async with AsyncCamoufox(headless=True, main_world_eval=False) as browser:
    # ... code using window.wrappedJSObject
```

**Changed to:**
```python
async with AsyncCamoufox(headless=True, main_world_eval=True) as browser:
    # ... code using window directly
```

This allows direct access to the main window context without needing `wrappedJSObject`.

### Fix 2: Removed wrappedJSObject References
**Changed from:**
```python
const w = window.wrappedJSObject || window;
w.grecaptcha.enterprise.execute(...)
```

**Changed to:**
```python
window.grecaptcha.enterprise.execute(...)
```

This eliminates the permission errors by accessing the window object directly.

### Fix 3: Improved Cloudflare Challenge Detection
**Enhanced detection logic:**
- Check page title AND URL
- Verify we're not on a `/cdn-cgi/` redirect
- Check for actual page content (body text length)
- Multiple fallback detection methods

**Changed from:**
```python
if "Just a moment" not in title:
    challenge_passed = True
```

**Changed to:**
```python
if "Just a moment" not in title and "lmarena.ai" in url and "/cdn-cgi/" not in url:
    challenge_passed = True
# Plus additional content-based checks
```

## Testing

To test the fixes:

```bash
python test_fix.py
```

Or run the full server:

```bash
python src/main.py
```

Then send a test request:

```bash
curl -X POST http://localhost:8000/api/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "model": "gemini-3-flash",
    "messages": [{"role": "user", "content": "Hi"}]
  }'
```

## Expected Behavior

After these fixes:

1. ✅ No more "Permission denied to access object" errors
2. ✅ Better Cloudflare challenge detection and passing
3. ✅ reCAPTCHA tokens should be retrieved successfully
4. ✅ Chat requests should complete without getting stuck

## Notes

- The README mentions LMArena has implemented "ANTI-BOT MEASURES" - these fixes address the immediate technical issues, but LMArena may continue to evolve their bot detection
- If you still see Cloudflare challenges, the browser will now better detect when they're passed
- The Chrome fallback (`get_recaptcha_v3_token_with_chrome`) should work better now as well

## If Issues Persist

If you still encounter problems:

1. **Clear browser profile**: Delete the `chrome_grecaptcha` folder to start fresh
2. **Update cookies**: Make sure your `cf_clearance` cookie in `config.json` is current
3. **Check auth token**: Verify your `arena-auth-prod-v1` token is valid
4. **Manual verification**: If Cloudflare requires manual verification, complete it in the browser window that opens
