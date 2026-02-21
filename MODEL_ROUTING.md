# MODEL_ROUTING.md

แนวทางใช้โมเดลให้คุ้ม

## Routing แนะนำ
- งานสำคัญ/ซับซ้อน/โค้ดยาก: `openai-codex/gpt-5.3-codex`
- งานทั่วไป/สรุป/ร่างข้อความ: `kimi-coding/k2p5`
- เมื่อ Kimi key1 ตัน: ใช้ key2 อัตโนมัติผ่าน auth order

## Default ที่แนะนำ
- Primary: `openai-codex/gpt-5.3-codex`
- Fallback: `kimi-coding/k2p5`
- Kimi auth order: `kimi-coding:default -> kimi-coding:backup`

## กฎลดค่าใช้จ่าย
1. เริ่มจากคำถามสั้น/ชัดเจน
2. ให้ร่างสั้นก่อน แล้วค่อยขยายจุดสำคัญ
3. แยกงานยาวเป็นหลายรอบ
4. ปิดบริบทเดิมเมื่อเปลี่ยนเรื่องใหญ่
