# Tavily MCP News - 4GB RAM Profile (Safe Mode)

โปรไฟล์นี้เหมาะกับเครื่องสเปคเล็ก (RAM ~4GB)

## Default Settings
- Query scope: แคบและชัดเจน (1 หัวข้อ/ครั้ง)
- include_domains: 1-3 โดเมนต่อรอบ
- max_results: `5` (สูงสุด `8`)
- search_depth: `basic` (ใช้ `advanced` เมื่อจำเป็น)
- topic: `news`
- time_range: `week`
- timeout ต่อคำขอ: `20-30s`

## Tool Strategy
1. เริ่มด้วย `tavily-search`
2. เลือกเฉพาะลิงก์สำคัญ 2-4 ลิงก์ แล้วใช้ `tavily-extract`
3. ใช้ `tavily-map`/`tavily-crawl` เฉพาะงานเจาะลึกจริง ๆ

## Avoid (บนเครื่องนี้)
- Crawl หลายโดเมนพร้อมกัน
- max_pages สูง ๆ
- เปิด Chrome หลายแท็บพร้อมรัน Agent

## Practical Routine
- ปิดแท็บที่ไม่ใช้ก่อนรัน
- ถ้าหน่วง: ลด max_results ก่อนอย่างแรก
- ถ้ายังช้า: แยกคำถามเป็นหลายรอบ

## Output Standard
- ต้องมีลิงก์อ้างอิงทุกประเด็น
- แยก fact vs analysis
- ถ้าข้อมูลไม่พอ ให้ระบุชัดเจนว่า "ข้อมูลยังไม่พอ"
