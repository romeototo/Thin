---
name: github-backup
description: Auto-backup OpenClaw workspace to GitHub repository. Use when user wants to backup their workspace files, memory, and configuration to GitHub for disaster recovery. Supports scheduled automatic backups and manual backup operations.
---

# GitHub Backup

## Overview

สกิลสำหรับ backup OpenClaw workspace ขึ้น GitHub อัตโนมัติ รองรับทั้ง manual backup และ scheduled auto-backup

## When to Use

- ต้องการ backup workspace ขึ้น GitHub
- ต้องการตั้งค่า auto-backup ตาม schedule
- ต้องการ restore จาก GitHub

## Quick Start

### 1. Setup ครั้งแรก

```powershell
# รันสคริปต์ setup
.\scripts\setup-github-backup.ps1 -Username "YOUR_GITHUB_USERNAME" -Token "YOUR_GITHUB_TOKEN" -Repo "https://github.com/username/repo.git"
```

### 2. Manual Backup

```powershell
.\scripts\backup-to-github.ps1
```

### 3. Setup Auto-Backup (ทุก 24 ชั่วโมง)

```powershell
.\scripts\schedule-backup.ps1 -IntervalHours 24
```

## Workflow

### First-time Setup
1. ตรวจสอบ git initialized
2. Config git user
3. Add remote with token
4. Initial commit และ push

### Regular Backup
1. git add -A
2. git commit (ถ้ามีการเปลี่ยนแปลง)
3. git push

## Resources

### scripts/
- `setup-github-backup.ps1` - Setup ครั้งแรก
- `backup-to-github.ps1` - Manual backup
- `schedule-backup.ps1` - ตั้งค่า scheduled task

## Configuration

เก็บ config ไว้ที่ `.openclaw\backup-config.json`:
```json
{
  "username": "romeototo",
  "repo": "https://github.com/romeototo/Thin.git",
  "branch": "main",
  "schedule": "0 0 * * *"
}
```
