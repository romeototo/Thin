# Auto-generated rollback script
Copy-Item -Force ""C:\Users\admin\.openclaw\backups\openclaw.ultralite-safe2.20260222_035741.json"" ""C:\Users\admin\.openclaw\openclaw.json""
openclaw gateway restart
openclaw status
