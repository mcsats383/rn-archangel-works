# Backend Setup & Installation Guide

## Prerequisites

- Node.js v14+ installed
- MongoDB Atlas account (free tier)
- Git

## Installation Steps

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Setup MongoDB Atlas

1. Go to https://www.mongodb.com/cloud/atlas
2. Sign up for free account
3. Create a new cluster (Free tier)
4. Create database user
5. Get connection string

### 3. Create Environment File

```bash
cp .env.example .env
```

Edit `.env` file and add your MongoDB connection string:

```env
PORT=5000
NODE_ENV=development
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/rn-archangel-works?retryWrites=true&w=majority
JWT_SECRET=your_secure_jwt_secret_key_change_this
JWT_EXPIRES_IN=7d
CLIENT_URL=http://localhost:3000
```

### 4. Run Development Server

```bash
npm run dev
```

Server should start on `http://localhost:5000`

### 5. Test API

Open browser and go to:
```
http://localhost:5000/
```

You should see:
```json
{
  "message": "Rn Archangel Works API is running",
  "version": "1.0.0",
  "status": "ok"
}
```

## API Endpoints

### Base URL
```
http://localhost:5000/api
```

### Authentication

**Register User**
```
POST /api/auth/register
Content-Type: application/json

{
  "name": "Admin User",
  "email": "admin@example.com",
  "password": "password123",
  "phone": "0812345678",
  "role": "admin"
}
```

**Login**
```
POST /api/auth/login
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "password123"
}
```

Response:
```json
{
  "message": "Login successful",
  "user": {
    "id": "...",
    "name": "Admin User",
    "email": "admin@example.com",
    "role": "admin"
  },
  "token": "eyJhbGc..."
}
```

### Projects

**Get All Projects**
```
GET /api/projects
```

**Get Single Project**
```
GET /api/projects/:id
```

**Create Project (Admin only)**
```
POST /api/projects
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Project Name",
  "description": "Project description",
  "location": "Location",
  "budget": 100000,
  "status": "planning",
  "category": "construction"
}
```

**Update Project (Admin only)**
```
PUT /api/projects/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "in-progress"
}
```

**Delete Project (Admin only)**
```
DELETE /api/projects/:id
Authorization: Bearer <token>
```

### Contacts

**Get All Contacts (Admin only)**
```
GET /api/contacts
Authorization: Bearer <token>
```

**Submit Contact Form**
```
POST /api/contacts
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "0812345678",
  "subject": "consulting",
  "message": "I would like to consult about..."
}
```

**Update Contact (Admin only)**
```
PUT /api/contacts/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "replied"
}
```

### News

**Get All News**
```
GET /api/news
```

**Get Single News**
```
GET /api/news/:id
```

**Create News (Admin only)**
```
POST /api/news
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "News Title",
  "category": "news",
  "content": "News content here...",
  "image": "https://example.com/image.jpg",
  "author": "Author Name"
}
```

**Update News (Admin only)**
```
PUT /api/news/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Updated Title"
}
```

**Delete News (Admin only)**
```
DELETE /api/news/:id
Authorization: Bearer <token>
```

### Payments

**Get All Payments (Admin only)**
```
GET /api/payments
Authorization: Bearer <token>
```

**Create Payment**
```
POST /api/payments
Authorization: Bearer <token>
Content-Type: application/json

{
  "amount": 50000,
  "method": "promptpay",
  "projectId": "project_id_optional"
}
```

### Dashboard

**Get Dashboard Stats (Admin only)**
```
GET /api/dashboard
Authorization: Bearer <token>
```

Response:
```json
{
  "totalProjects": 5,
  "totalContacts": 12,
  "totalNews": 8,
  "totalPayments": 3
}
```

## Using Postman

1. Download Postman: https://www.postman.com/downloads/
2. Create new workspace
3. Test endpoints following examples above
4. Use token from login response in Authorization header

## Troubleshooting

### MongoDB Connection Error

Make sure:
- MongoDB URI is correct
- IP address is whitelisted in MongoDB Atlas
- Database exists

### Port Already in Use

```bash
# Change port in .env file or kill process
lsof -ti:5000 | xargs kill -9
```

### Module Not Found

```bash
rm -rf node_modules package-lock.json
npm install
```

## Production Deployment

See `DEPLOYMENT.md` for DigitalOcean deployment guide.

## Support

For issues or questions:
- Email: support@rnarchangelworks.com
- GitHub Issues: [repository issues page]
