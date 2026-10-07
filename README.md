# Rn Archangel Works

Rn Archangel Works เป็น landing page + backend system สำหรับบริษัทก่อสร้าง ออกแบบ และงานลงทุน โดยมีฟีเจอร์หลักดังนี้:
- Landing page แบบ static สำหรับแนะนำบริษัท
- API สำหรับจัดการข้อมูลโครงการ ข่าวสาร ผู้ติดต่อ และการชำระเงิน
- ระบบ authentication สำหรับแอดมิน
- MongoDB Atlas-ready สำหรับใช้งานบนคลาวด์

## โครงสร้าง Repository

- `index.html` - เว็บไซต์ landing page
- `backend/` - Server API สำหรับ backend

## Quick Start

### 1. Install dependencies

```bash
cd backend
npm install
```

### 2. Setup environment

```bash
cp .env.example .env
```

แก้ไขค่า `MONGODB_URI` และ `JWT_SECRET` ตามค่าจริง

### 3. Run server

```bash
npm run dev
```

หรือ

```bash
npm start
```

## Base URL

```bash
http://localhost:5000/api
```

## API Overview

- Auth: `/api/auth`
- Projects: `/api/projects`
- Contacts: `/api/contacts`
- News: `/api/news`
- Payments: `/api/payments`
- Dashboard: `/api/dashboard`

## Default Admin

ถ้าไม่มีผู้ใช้งาน admin ให้สร้างด้วยการสมัครสมาชิกแบบ admin ในเครื่องมือ MongoDB หรือใช้ API register พร้อมกำหนด role manually

## Notes

- Repository นี้ยังไม่ deploy ไปยัง DigitalOcean ในตอนนี้
- ใช้เป็นเวอร์ชัน development เพื่อเตรียมพร้อมสำหรับ deploy ในภายหลัง
- การ deploy และ production setup จะมีเอกสารแยกต่อไป
