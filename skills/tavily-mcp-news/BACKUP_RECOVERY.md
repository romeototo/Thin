# Backup & Recovery (Tavily Skill)

## Backup created
- Type: Zip snapshot (local)
- Folder: `backups/`
- Latest file: ดูไฟล์ชื่อ `workspace-backup-YYYYMMDD-HHMMSS.zip`

## Quick restore (safe)
1. ปิดงานที่เกี่ยวข้องก่อน
2. แตก zip ไปโฟลเดอร์ชั่วคราว
3. คัดลอกเฉพาะไฟล์ที่ต้องการกลับเข้า workspace

## Full workspace rollback (Git)
> ใช้เมื่อมั่นใจว่าต้องย้อนทั้งชุด

```powershell
git log --oneline -n 20
git reset --hard <commit>
```

## OpenClaw recovery helper
มีสคริปต์ช่วยกู้ระบบ:
- `scripts/recover-openclaw.ps1`

รัน:
```powershell
& "C:\Users\admin\.openclaw\workspace\scripts\recover-openclaw.ps1"
```
