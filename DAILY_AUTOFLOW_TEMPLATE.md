# DAILY_AUTOFLOW_TEMPLATE.md

## เป้าหมาย
เทมเพลตส่งงานรายวันแบบข้อความเดียวให้ main คุม flow:
trend → research → content → qa → main → discord

---

## 1) MASTER BRIEF (ส่งให้ main)
คัดลอกแล้วกรอกช่อง `{...}`

```text
[MASTER BRIEF]
วันที่: {YYYY-MM-DD}
แคมเปญ: {ชื่อแคมเปญ}
หมวดสินค้า: {เช่น gadget บ้าน / ของใช้แม่บ้าน / มือถือ}
จำนวนสินค้าที่ต้องการคัด: {5-10}
โทนโพสต์: {minimal / กันเอง / โปรแรง}
ข้อห้าม: {เช่น ห้ามเคลมเกินจริง}
KPI วันนี้: CTR >= {x%}, Conversion >= {y%}

FLOW บังคับ:
1) trend หาเทรนด์ + สินค้าเริ่มพุ่ง
2) research วิเคราะห์ pain point + hook 3 แบบ/สินค้า
3) content เขียนโพสต์ A/B ต่อสินค้า
4) qa ตรวจและเลือกเวอร์ชันผ่าน
5) main เลือกโพสต์สุดท้าย 2 โพสต์
6) discord นำไปใช้ขาย + เก็บ insight ลูกค้า

OUTPUT สุดท้ายที่ต้องส่งกลับ:
[DAILY DECISION] + [DISCORD INSIGHT]
```

---

## 2) TASK MESSAGE แยกตาม agent (พร้อมส่ง)

### ส่งให้ trend
```text
[TASK -> trend]
ใช้ PROMPT_TREND.md
โจทย์วันนี้: หมวด {หมวดสินค้า}
ต้องการ: สินค้าเริ่มพุ่ง 5-10 ตัว + keyword ที่พบ
รูปแบบตอบ: [TREND LIST]
```

### ส่งให้ research
```text
[TASK -> research]
ใช้ PROMPT_RESEARCH.md
อินพุต: ผลจาก [TREND LIST]
ต้องการ: Pain Point + Hook 1/2/3 ต่อสินค้า
รูปแบบตอบ: [RESEARCH RESULT]
```

### ส่งให้ content
```text
[TASK -> content]
ใช้ PROMPT_CONTENT.md
อินพุต: [RESEARCH RESULT]
ต้องการ: โพสต์ A/B ต่อสินค้า (สั้น กระชับ มี CTA)
รูปแบบตอบ: [CONTENT DRAFT]
```

### ส่งให้ qa
```text
[TASK -> qa]
ใช้ PROMPT_QA.md
อินพุต: [CONTENT DRAFT]
ต้องการ: คัดโพสต์ที่ผ่าน + เหตุผล + เวอร์ชันแก้
รูปแบบตอบ: [QA APPROVED]
```

### ส่งให้ main
```text
[TASK -> main]
ใช้ PROMPT_MAIN.md
อินพุต: [QA APPROVED] + [DISCORD INSIGHT ล่าสุด]
ต้องการ: เลือก 2 โพสต์ดีที่สุดของวัน
รูปแบบตอบ: [DAILY DECISION]
```

### ส่งให้ discord
```text
[TASK -> discord]
ใช้ PROMPT_DISCORD.md
อินพุต: โพสต์ที่ main เลือก
ต้องการ: นำไปใช้ตอบ/ขาย + เก็บคำถามจริง
รูปแบบตอบ: [DISCORD INSIGHT]
```

---

## 3) CHECKLIST MAIN (ก่อนจบวัน)
- [ ] ได้ [TREND LIST]
- [ ] ได้ [RESEARCH RESULT]
- [ ] ได้ [CONTENT DRAFT]
- [ ] ได้ [QA APPROVED]
- [ ] ได้ [DAILY DECISION]
- [ ] ได้ [DISCORD INSIGHT]
- [ ] บันทึก Top 2 โพสต์ + เหตุผลที่ชนะ

---

## 4) สรุปผลรายวัน (คัดลอกใช้ได้ทันที)
```text
[END OF DAY REPORT]
วันที่:
สินค้า Top 2:
โพสต์ที่ใช้จริง:
CTR โดยรวม:
Conversion โดยรวม:
คำถามที่ลูกค้าถามบ่อย:
Pain point ที่เจอจริง:
สิ่งที่ต้องปรับพรุ่งนี้:
```
