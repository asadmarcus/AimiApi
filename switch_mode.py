"""
Switch between authenticated and anonymous mode
"""
import json
import shutil
from datetime import datetime

def backup_config():
    """Backup current config"""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = f"config.json.backup_{timestamp}"
    shutil.copy("config.json", backup_file)
    print(f"✅ Backed up config to: {backup_file}")
    return backup_file

def load_config():
    """Load current config"""
    with open('config.json', 'r') as f:
        return json.load(f)

def save_config(config):
    """Save config"""
    with open('config.json', 'w') as f:
        json.dump(config, f, indent=4)

def show_current_mode():
    """Show current authentication mode"""
    config = load_config()
    auth_tokens = config.get('auth_tokens', [])
    provisional_id = config.get('provisional_user_id', '')
    
    print("\n" + "=" * 70)
    print("🔍 Current Mode")
    print("=" * 70)
    
    if auth_tokens:
        print(f"✅ AUTHENTICATED MODE")
        print(f"   - {len(auth_tokens)} auth token(s) configured")
        print(f"   - Using logged-in Google account(s)")
    else:
        print(f"✅ ANONYMOUS MODE")
        print(f"   - No auth tokens")
        if provisional_id:
            print(f"   - Provisional ID: {provisional_id[:30]}...")
        else:
            print(f"   - Will auto-generate provisional ID")
    
    print("=" * 70)

def switch_to_anonymous():
    """Switch to anonymous mode"""
    print("\n🔄 Switching to ANONYMOUS mode...")
    
    backup_config()
    config = load_config()
    
    # Keep a backup of auth tokens in case user wants to switch back
    if config.get('auth_tokens'):
        config['_auth_tokens_backup'] = config['auth_tokens']
    
    # Clear auth tokens
    config['auth_tokens'] = []
    
    save_config(config)
    
    print("\n✅ Switched to ANONYMOUS mode!")
    print("   - Auth tokens removed (backed up in config)")
    print("   - Will use provisional_user_id for anonymous access")
    print("   - Restart server: python src/main.py")

def switch_to_authenticated():
    """Switch to authenticated mode"""
    print("\n🔄 Switching to AUTHENTICATED mode...")
    
    config = load_config()
    
    # Try to restore from backup
    if config.get('_auth_tokens_backup'):
        backup_config()
        config['auth_tokens'] = config['_auth_tokens_backup']
        del config['_auth_tokens_backup']
        save_config(config)
        
        print("\n✅ Switched to AUTHENTICATED mode!")
        print(f"   - Restored {len(config['auth_tokens'])} auth token(s)")
        print("   - Will use logged-in Google account(s)")
        print("   - Restart server: python src/main.py")
    else:
        print("\n⚠️  No auth tokens found in backup!")
        print("   You need to add auth tokens manually:")
        print("   1. Sign in to lmarena.ai with Google")
        print("   2. Get arena-auth-prod-v1 cookie (F12 → Application → Cookies)")
        print("   3. Add to config.json auth_tokens array")

def main():
    print("=" * 70)
    print("🔀 LMArena Bridge - Mode Switcher")
    print("=" * 70)
    
    show_current_mode()
    
    print("\nWhat would you like to do?")
    print("  1. Switch to ANONYMOUS mode (no login)")
    print("  2. Switch to AUTHENTICATED mode (with login)")
    print("  3. Show current mode")
    print("  4. Exit")
    
    choice = input("\nEnter choice (1-4): ").strip()
    
    if choice == "1":
        confirm = input("\n⚠️  This will remove auth tokens. Continue? (y/n): ").strip().lower()
        if confirm == 'y':
            switch_to_anonymous()
        else:
            print("❌ Cancelled")
    
    elif choice == "2":
        switch_to_authenticated()
    
    elif choice == "3":
        show_current_mode()
    
    elif choice == "4":
        print("\n👋 Goodbye!")
    
    else:
        print("\n❌ Invalid choice")

if __name__ == "__main__":
    main()
