---
name: google-gemini-setup
description: Setup and configure Google Gemini API as fallback model for OpenClaw. Use when user wants to add Gemini Pro as backup model or when Gemini configuration needs fixing.
---

# Google Gemini Setup Skill

## Overview

สกิลสำหรับตั้งค่า Google Gemini API ให้ใช้งานได้จริงกับ OpenClaw

## Prerequisites

1. มี Google AI Studio API Key (จาก https://aistudio.google.com/app/apikey)
2. API Key ต้อง Active และมี Quota เหลือ

## Setup Steps

### Step 1: Verify API Key

ทดสอบว่า API Key ใช้งานได้:
```bash
curl "https://generativelanguage.googleapis.com/v1/models?key=YOUR_API_KEY"
```

ถ้าได้รายการโมเดลกลับมา = Key ใช้ได้

### Step 2: Update OpenClaw Config

แก้ไข `openclaw.json` ตามนี้:

```json
{
  "auth": {
    "profiles": {
      "google:default": {
        "provider": "google",
        "mode": "api_key"
      }
    }
  },
  "models": {
    "providers": {
      "google": {
        "baseUrl": "https://generativelanguage.googleapis.com/v1",
        "apiKey": "YOUR_API_KEY_HERE",
        "auth": "api-key",
        "api": "google-generative-ai",
        "models": [
          {
            "id": "gemini-pro",
            "name": "Gemini Pro",
            "input": ["text", "image"],
            "contextWindow": 30720
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "kimi-coding/k2p5",
        "fallbacks": ["gemini-pro"]
      },
      "models": {
        "kimi-coding/k2p5": {
          "alias": "Kimi K2.5"
        },
        "gemini-pro": {
          "alias": "Gemini Pro"
        }
      }
    }
  }
}
```

### Step 3: Restart OpenClaw

```bash
openclaw gateway restart
```

### Step 4: Test Connection

ทดสอบด้วยการสร้าง sub-agent:
```javascript
sessions_spawn({
  task: "ทดสอบ Gemini API",
  model: "gemini-pro",
  label: "gemini-test"
})
```

## Important Notes

1. **Model ID ที่ถูกต้อง:** ใช้ `gemini-pro` ไม่ใช่ `gemini-1.5-flash` หรือ `google/gemini-pro`

2. **Base URL:** ใช้ `v1` ไม่ใช่ `v1beta` (v1beta อาจไม่เสถียร)

3. **Context Window:** Gemini Pro รองรับ ~30k tokens (ไม่ใช่ 1M หรือ 2M)

4. **Security:** เก็บ API Key ใน `openclaw.json` อย่างเดียว อย่าแชร์ใน chat

## Troubleshooting

### Error: "Model not allowed"
- ตรวจสอบว่าใช้ชื่อ `gemini-pro` (ไม่มี prefix `google/`)
- ตรวจสอบว่ามีการกำหนดใน `agents.defaults.models`

### Error: "404 Not Found"
- ตรวจสอบ `baseUrl` ต้องเป็น `v1` ไม่ใช่ `v1beta`
- ตรวจสอบว่า `models` array มี `id` ถูกต้อง

### Error: "Invalid API Key"
- ไปที่ https://aistudio.google.com/app/apikey
- สร้าง Key ใหม่
- เปิด Billing ถ้าจำเป็น

## Fallback Chain

หลังจากตั้งค่าเสร็จ ระบบจะทำงานแบบนี้:
1. Primary: Kimi K2.5
2. Fallback: Gemini Pro (ถ้า Kimi fail)

## Resources

- Google AI Studio: https://aistudio.google.com
- Gemini API Docs: https://ai.google.dev/gemini-api/docs
- Pricing: https://ai.google.dev/pricing
