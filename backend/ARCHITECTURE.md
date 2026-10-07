# Backend Architecture & File Structure

```
/backend
├── server.js                 # Main server entry point
├── package.json             # Dependencies & scripts
├── .env.example             # Environment template
├── .gitignore              # Git ignore rules
│
├── /config
│   └── database.js         # MongoDB connection config
│
├── /models                 # Database schemas
│   ├── User.js            # User model
│   ├── Project.js         # Project model
│   ├── Contact.js         # Contact/Lead model
│   ├── News.js            # News/Blog model
│   └── Payment.js         # Payment model
│
├── /controllers            # Business logic (optional for expansion)
│   └── (Future expansion)
│
├── /routes                 # API endpoints
│   ├── auth.js            # Authentication endpoints
│   ├── projects.js        # Project CRUD endpoints
│   ├── contacts.js        # Contact form endpoints
│   ├── news.js            # News CRUD endpoints
│   ├── payments.js        # Payment endpoints
│   └── dashboard.js       # Dashboard stats endpoints
│
├── /middleware            # Custom middleware
│   ├── auth.js           # JWT verification & authorization
│   └── errorHandler.js   # Error handling middleware
│
├── /docs                 # Documentation
│   ├── SETUP.md         # Installation & setup guide
│   ├── DEPLOYMENT.md    # DigitalOcean deployment
│   └── API_TESTING.md   # API testing examples
│
└── /uploads             # User uploads (future)
    └── .gitkeep
```

## API Routes Overview

### Authentication Routes (`/routes/auth.js`)
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login and get JWT token
- `GET /api/auth/me` - Get current user info

### Project Routes (`/routes/projects.js`)
- `GET /api/projects` - Get all projects
- `GET /api/projects/:id` - Get single project
- `POST /api/projects` - Create project (Admin)
- `PUT /api/projects/:id` - Update project (Admin)
- `DELETE /api/projects/:id` - Delete project (Admin)

### Contact Routes (`/routes/contacts.js`)
- `POST /api/contacts` - Submit contact form (Public)
- `GET /api/contacts` - Get all contacts (Admin)
- `PUT /api/contacts/:id` - Update contact status (Admin)

### News Routes (`/routes/news.js`)
- `GET /api/news` - Get all news (Public)
- `GET /api/news/:id` - Get single news (Public)
- `POST /api/news` - Create news (Admin)
- `PUT /api/news/:id` - Update news (Admin)
- `DELETE /api/news/:id` - Delete news (Admin)

### Payment Routes (`/routes/payments.js`)
- `POST /api/payments` - Create payment
- `GET /api/payments` - Get all payments (Admin)

### Dashboard Routes (`/routes/dashboard.js`)
- `GET /api/dashboard` - Get dashboard stats (Admin)

## Security Features

### Authentication
- JWT (JSON Web Tokens) for stateless auth
- Token expiration: 7 days (configurable)
- Secure password hashing with bcryptjs

### Authorization
- Role-based access control (RBAC)
- Admin-only endpoints protected
- Public endpoints for contact forms

### Input Validation
- express-validator for request validation
- Email format validation
- Required field validation

### Error Handling
- Centralized error handler middleware
- Consistent error response format
- Stack traces in development only

## Dependencies

| Package | Purpose |
|---------|----------|
| express | Web framework |
| mongoose | MongoDB ODM |
| bcryptjs | Password hashing |
| jsonwebtoken | JWT tokens |
| express-validator | Input validation |
| cors | CORS handling |
| dotenv | Environment variables |
| morgan | HTTP request logging |
| nodemon | Development auto-reload |

## Environment Variables

```env
PORT=5000                    # Server port
NODE_ENV=development         # development/production
MONGODB_URI=mongodb+srv://...  # MongoDB connection
JWT_SECRET=secret_key        # JWT signing key
JWT_EXPIRES_IN=7d            # Token expiration
CLIENT_URL=http://localhost:3000  # Frontend URL
```

## Running the Server

### Development
```bash
npm run dev
```

### Production
```bash
npm start
```

## MongoDB Collections

### users
```javascript
{
  _id: ObjectId,
  name: String,
  email: String (unique),
  password: String (hashed),
  role: String (admin/user),
  phone: String,
  createdAt: Date,
  updatedAt: Date
}
```

### projects
```javascript
{
  _id: ObjectId,
  title: String,
  description: String,
  location: String,
  category: String,
  budget: Number,
  status: String (planning/in-progress/completed),
  images: [String],
  createdBy: ObjectId (ref: User),
  createdAt: Date,
  updatedAt: Date
}
```

### contacts
```javascript
{
  _id: ObjectId,
  name: String,
  email: String,
  phone: String,
  subject: String,
  message: String,
  status: String (new/replied/closed),
  createdAt: Date,
  updatedAt: Date
}
```

### news
```javascript
{
  _id: ObjectId,
  title: String,
  category: String,
  content: String,
  image: String,
  author: String,
  publishedDate: Date,
  createdAt: Date,
  updatedAt: Date
}
```

### payments
```javascript
{
  _id: ObjectId,
  amount: Number,
  method: String (promptpay/credit_card/bank_transfer),
  status: String (pending/paid/failed),
  transactionId: String,
  projectId: ObjectId (ref: Project),
  createdAt: Date,
  updatedAt: Date
}
```

## Middleware Chain

```
Request
  ↓
CORS
  ↓
JSON Parser
  ↓
Logger (Morgan)
  ↓
Routes
  ├─ auth.js (Optional JWT)
  ├─ projects.js (Protected routes)
  ├─ contacts.js (Public + Protected)
  ├─ news.js (Public + Protected)
  ├─ payments.js (Protected)
  └─ dashboard.js (Protected)
  ↓
Error Handler
  ↓
Response
```

## Next Steps

1. ✅ Backend structure created
2. ✅ All API routes implemented
3. ⏳ Admin Dashboard (Phase 2)
4. ⏳ Payment Gateway Integration (Phase 3)
5. ⏳ AI Chatbot (Phase 4)
