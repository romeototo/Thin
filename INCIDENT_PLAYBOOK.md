# INCIDENT_PLAYBOOK.md

## อาการ: OpenAI timeout + Kimi rate_limit พร้อมกัน

ทำตามลำดับนี้:
1. ลดขนาดคำถาม (สั้นลง 50-70%)
2. แยกคำสั่งเป็น 1 งานต่อ 1 ข้อความ
3. รอ 60-120 วินาทีแล้วลองใหม่
4. ตรวจสถานะ:
   - `openclaw models status --probe --probe-provider kimi-coding`
   - `openclaw logs --follow`

## กรณีต้องสลับลำดับ Kimi ชั่วคราว
- `openclaw models auth order set --provider kimi-coding kimi-coding:backup kimi-coding:default`
- เช็ค: `openclaw models auth order get --provider kimi-coding`

## กรณี key รั่ว/ต้องหมุน key
1. ออก key ใหม่จากผู้ให้บริการ
2. อัปเดตใน `~/.openclaw/agents/main/agent/auth-profiles.json`
3. probe ซ้ำให้ผ่าน
4. ยกเลิก key เก่าที่หน้า provider ทันที
