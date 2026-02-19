---
name: token-saver-template
description: Template for creating new skills with token-efficient structure. Use when user wants to create a new skill or when repetitive coding tasks are needed.
---

# Token Saver Skill Template

## Overview

สกิลนี้เป็น template สำหรับสร้างสกิลใหม่ที่ประหยัด token มีโครงสร้างมาตรฐาน

## Token-Efficient Structure

### 1. โครงสร้าง Skill แนะนำ
```
my-skill/
├── SKILL.md              # เอกสารหลัก (สั้น กระชับ)
├── scripts/              # โค้ดที่ใช้บ่อย
│   ├── main.py          # ฟังก์ชันหลัก
│   └── helpers.py       # ตัวช่วย
└── references/          # เอกสารอ้างอิง (โหลดเมื่อจำเป็น)
    └── advanced.md
```

### 2. หลักการเขียน SKILL.md

**แนะนำ:**
- ใช้ bullet points แทน paragraph ยาว
- ให้ตัวอย่างโค้ดที่ copy-paste ได้เลย
- อ้างอิงไฟล์อื่นแทนการเขียนซ้ำ

**ตัวอย่างที่ดี:**
```markdown
## Quick Start
1. รัน `scripts/setup.py`
2. ใช้ `scripts/main.py --help`

## รายละเอียดเพิ่มเติม
ดู [references/advanced.md](references/advanced.md)
```

### 3. การใช้ Sub-agents อย่างมีประสิทธิภาพ

```javascript
// แยกงานใหญ่ออกเป็นส่วนย่อย
sessions_spawn({
  task: "วิเคราะห์ส่วน A",
  label: "part-a",
  cleanup: "delete"  // ลบเมื่อเสร็จ
})

sessions_spawn({
  task: "วิเคราะห์ส่วน B",
  label: "part-b",
  cleanup: "delete"
})

// รวมผลลัพธ์ใน session หลัก
```

## Workflow ประหยัด Token

### Pattern 1: Research Task
```
1. spawn sub-agent ค้นหาข้อมูล
2. สรุปผลสั้นๆ กลับมา
3. เก็บสรุปใน memory
4. /reset session
```

### Pattern 2: Coding Task
```
1. สร้าง skill สำหรับโค้ดนั้น
2. เก็บใน scripts/
3. เรียกใช้ skill แทนการเขียนใหม่
4. commit ขึ้น git
```

### Pattern 3: Analysis Task
```
1. แยกไฟล์ใหญ่เป็นส่วนย่อย
2. spawn หลาย sub-agents ทำพร้อมกัน
3. รวมผลลัพธ์
4. สร้างสรุปกระชับ
```

## Best Practices

### 1. Memory Management
- เขียน memory กระชับ
- ใช้ bullet points
- อ้างอิงไฟล์แทนการ copy ข้อความยาว

### 2. Context Management
- ใช้ /new ทุก 50-100 ข้อความ
- spawn sub-agents สำหรับงานย่อย
- ตั้งค่า auto-prune

### 3. Tool Usage
- ใช้ skill แทนการเขียนโค้ดซ้ำ
- เก็บ script ที่ใช้บ่อย
- อ่านไฟล์ reference เฉพาะเมื่อจำเป็น
