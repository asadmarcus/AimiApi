# Browser Window Not Opening - Fixed

## Problem
The browser wasn't opening because it was running in headless mode, which LMArena's anti-bot measures often block.

## Solution Applied

### 1. Changed Default to Headed Mode
The browser will now open visibly by default so you can:
- See the Cloudflare challenges
- Manually complete any verification if needed
- Watch the automation process

### 2. Added Config Control
You can now control headless mode via `config.json`:

```json
{
  "camoufox_fetch_headless": false  // false = browser visible, true = headless
}
```

## What to Expect Now

When you restart the server:

1. **Browser Window Opens** - You'll see a Firefox-based browser window open
2. **Cloudflare Challenge** - If Cloudflare shows a challenge, you can manually click the checkbox
3. **Automatic Detection** - The code will detect when the challenge passes and continue
4. **Data Extraction** - Models and tokens will be extracted automatically

## Testing

1. **Stop the current server** (Ctrl+C if still running)
2. **Restart the server:**
   ```bash
   python src/main.py
   ```
3. **Watch the browser window** - It should open and navigate to lmarena.ai
4. **Complete any challenges** - If Cloudflare shows a checkbox, click it
5. **Wait for completion** - The server will continue once the challenge passes

## If You Prefer Headless Mode

If you want to run headless (no visible browser), set in `config.json`:

```json
{
  "camoufox_fetch_headless": true
}
```

**Note:** Headless mode may fail more often due to LMArena's anti-bot measures.

## Troubleshooting

### Browser Opens But Gets Stuck
- Manually click any Cloudflare checkboxes you see
- Wait for the page to fully load (you should see the LMArena interface)
- The code will auto-detect when it's ready

### Browser Closes Immediately
- Check the console for error messages
- Ensure your `cf_clearance` cookie in config.json is current
- Try deleting the `chrome_grecaptcha` folder and restart

### Still No Browser Window
- Make sure `camoufox_fetch_headless` is set to `false` in config.json
- Check if Camoufox is properly installed: `pip install camoufox`
- Try reinstalling: `pip uninstall camoufox && pip install camoufox`
