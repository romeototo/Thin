---
name: openclaw-updater
description: Update OpenClaw to the latest version via npm. Handles version checking, npm update, and gateway restart automatically.
---

# OpenClaw Updater Skill

## Overview

สกิลสำหรับอัปเดต OpenClaw เป็นเวอร์ชันล่าสุด รองรับการตรวจสอบเวอร์ชัน อัปเดตผ่าน npm และรีสตาร์ต gateway อัตโนมัติ

## When to Use

- ต้องการอัปเดต OpenClaw เป็นเวอร์ชันล่าสุด
- แก้ไขบั๊กหรือปัญหาความเข้ากันได้ (เช่น Gemini API error)
- ต้องการฟีเจอร์ใหม่จากเวอร์ชันล่าสุด

## Quick Start

### วิธีที่ 1: ใช้ PowerShell Scripts

```powershell
# ตรวจสอบเวอร์ชันก่อน
.\skills\openclaw-updater\scripts\check-version.ps1

# อัปเดตอย่างง่าย
.\skills\openclaw-updater\scripts\update-openclaw.ps1

# อัปเดตแบบเต็มรูปแบบ (แนะนำ)
.\skills\openclaw-updater\scripts\full-update.ps1
```

### วิธีที่ 2: ใช้ผ่าน OpenClaw Agent

ขอให้ไอติม (หรือ agent อื่น) รันคำสั่ง:
- "อัปเดต OpenClaw ให้หน่อย"
- "เช็คเวอร์ชัน OpenClaw"
- "รัน full update"

## Scripts Reference

| Script | ใช้ทำอะไร | แนะนำ |
|--------|----------|-------|
| `check-version.ps1` | ตรวจสอบเวอร์ชันปัจจุบัน vs ล่าสุด | ⭐ รันก่อนอัปเดต |
| `update-openclaw.ps1` | อัปเดต + รีสตาร์ต | อัปเดตทั่วไป |
| `full-update.ps1` | สำรอง → อัปเดต → รีสตาร์ต → ตรวจสอบ | ⭐ แนะนำมาก |

### Options

```powershell
# อัปเดตโดยไม่สำรอง config
.\scripts\update-openclaw.ps1 -SkipBackup

# อัปเดตโดยไม่รีสตาร์ต gateway
.\scripts\update-openclaw.ps1 -SkipRestart

# บังคับรันทั้ง ๆ ที่ไม่มีสิทธิ์ admin
.\scripts\update-openclaw.ps1 -Force
```

## Workflow

```
1. Check Version    → ดูเวอร์ชันปัจจุบัน vs ล่าสุด
2. Backup Config    → สำรอง openclaw.json อัตโนมัติ
3. npm update       → รัน npm update -g openclaw
4. Restart Gateway  → openclaw gateway restart
5. Verify           → ตรวจสอบว่าอัปเดตสำเร็จ
```

## What Gets Updated

✅ **อัปเดต:**
- OpenClaw core (เวอร์ชันโปรแกรม)
- Dependencies ใหม่
- Bug fixes
- ฟีเจอร์ใหม่

🛡️ **ไม่เปลี่ยนแปลง:**
- Workspace files
- Memory files (MEMORY.md, memory/)
- Config (openclaw.json) - มีสำรองก่อน
- API keys

## Troubleshooting

### อัปเดตไม่สำเร็จ (Permission Denied)
```powershell
# รันด้วยสิทธิ์ Administrator
# คลิกขวา PowerShell → Run as Administrator
```

### npm update ล้มเหลว
สคริปต์จะลอง `npm install -g openclaw@latest` อัตโนมัติ

### Gateway ไม่รีสตาร์ต
```powershell
# รีสตาร์ตเองด้วย
openclaw gateway restart

# หรือ stop แล้ว start ใหม่
openclaw gateway stop
openclaw gateway start
```

### ต้องการ Rollback
```powershell
# หาไฟล์สำรอง
ls $env:USERPROFILE\.openclaw\backups\

# คืนค่า config
copy $env:USERPROFILE\.openclaw\backups\openclaw-XXXX.json $env:USERPROFILE\.openclaw\openclaw.json

# ย้อนเวอร์ชัน
npm install -g openclaw@2026.2.15
```

## Safety Features

- ✅ สำรอง config อัตโนมัติก่อนอัปเดต
- ✅ สำรอง workspace ก่อน full-update
- ✅ ตรวจสอบสิทธิ์ admin ก่อนรัน
- ✅ ไม่ลบไฟล์สำคัญ
- ✅ แสดง error messages ชัดเจน

## Requirements

- Windows PowerShell 5.1+
- npm ติดตั้งอยู่
- Internet connection
- สิทธิ์เขียนใน Program Files (ถ้า npm ติดตั้งที่นั่น)

## Related

- [GitHub Backup Skill](../github-backup/) - สำรองก่อนอัปเดต
- [Google Gemini Setup](../google-gemini-setup/) - แก้ไขปัญหา Gemini

## Last Updated

สร้าง: 2026-02-20
สกิลเวอร์ชัน: 1.0
