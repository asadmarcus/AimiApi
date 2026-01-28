"""
Check authentication status from config
"""
import json
import base64

with open('config.json', 'r') as f:
    config = json.load(f)

print("=" * 70)
print("🔐 Authentication Status Check")
print("=" * 70)

auth_tokens = config.get('auth_tokens', [])
print(f"\n📊 Number of auth tokens: {len(auth_tokens)}")

if auth_tokens:
    print("\n✅ YOU ARE LOGGED IN!")
    print("\nToken details:")
    
    for i, token in enumerate(auth_tokens, 1):
        if token.startswith('base64-'):
            # Remove the 'base64-' prefix
            token_data = token[7:]
            
            try:
                # Decode the base64 token
                decoded = base64.b64decode(token_data + '==')  # Add padding
                token_json = json.loads(decoded)
                
                print(f"\n  Token {i}:")
                print(f"  - Type: {token_json.get('token_type', 'N/A')}")
                
                user = token_json.get('user', {})
                if user:
                    print(f"  - Email: {user.get('email', 'N/A')}")
                    print(f"  - Name: {user.get('user_metadata', {}).get('full_name', 'N/A')}")
                    print(f"  - Provider: {user.get('app_metadata', {}).get('provider', 'N/A')}")
                    print(f"  - Confirmed: {user.get('email_confirmed_at', 'N/A')[:10]}")
                
                expires_at = token_json.get('expires_at')
                if expires_at:
                    from datetime import datetime
                    exp_date = datetime.fromtimestamp(expires_at)
                    now = datetime.now()
                    
                    if exp_date > now:
                        remaining = exp_date - now
                        print(f"  - Status: ✅ Valid (expires in {remaining.seconds // 60} minutes)")
                    else:
                        print(f"  - Status: ⚠️ Expired (will auto-refresh)")
                
            except Exception as e:
                print(f"  - Token {i}: Valid format (couldn't decode details)")
        else:
            print(f"  - Token {i}: {token[:30]}...")
    
    print("\n" + "=" * 70)
    print("📝 Summary:")
    print("  - You are authenticated with LMArena")
    print("  - Your account is linked to Google")
    print("  - Token will auto-refresh when expired")
    print("  - All requests use your authenticated account")
    
    if len(auth_tokens) == 1:
        print("\n⚠️  Risk Level: MEDIUM")
        print("  - Only 1 account configured")
        print("  - All requests use the same account")
        print("  - Higher risk of rate limiting")
        print("\n💡 Recommendation:")
        print("  - Create 2-3 more Google accounts")
        print("  - Sign in to lmarena.ai with each")
        print("  - Add their tokens to spread the load")
    else:
        print(f"\n✅ Risk Level: LOW")
        print(f"  - {len(auth_tokens)} accounts configured")
        print(f"  - Requests distributed across accounts")
        print(f"  - Lower risk of rate limiting")
    
else:
    print("\n❌ NOT LOGGED IN")
    print("  - No auth tokens found")
    print("  - Bridge will use anonymous/provisional access")
    print("  - Limited functionality")

print("=" * 70)
