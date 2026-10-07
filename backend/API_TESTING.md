# Testing API with cURL Examples

## Base URL

```
http://localhost:5000/api
```

## 1. Authentication Tests

### Register New User

```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Admin User",
    "email": "admin@example.com",
    "password": "password123",
    "phone": "0812345678",
    "role": "admin"
  }'
```

### Login

```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "password": "password123"
  }'
```

**Save the token from response for next requests**

### Get Current User

```bash
curl http://localhost:5000/api/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 2. Projects API

### Get All Projects

```bash
curl http://localhost:5000/api/projects
```

### Create Project (Admin)

```bash
curl -X POST http://localhost:5000/api/projects \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "title": "Modern Building Construction",
    "description": "A state-of-the-art residential building",
    "location": "Bangkok, Thailand",
    "budget": 5000000,
    "status": "planning",
    "category": "construction"
  }'
```

### Update Project (Admin)

```bash
curl -X PUT http://localhost:5000/api/projects/PROJECT_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "status": "in-progress"
  }'
```

### Delete Project (Admin)

```bash
curl -X DELETE http://localhost:5000/api/projects/PROJECT_ID \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 3. Contacts API

### Submit Contact Form (Public)

```bash
curl -X POST http://localhost:5000/api/contacts \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "0812345678",
    "subject": "consulting",
    "message": "I am interested in your construction services"
  }'
```

### Get All Contacts (Admin)

```bash
curl http://localhost:5000/api/contacts \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Update Contact Status (Admin)

```bash
curl -X PUT http://localhost:5000/api/contacts/CONTACT_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "status": "replied"
  }'
```

## 4. News API

### Get All News (Public)

```bash
curl http://localhost:5000/api/news
```

### Create News (Admin)

```bash
curl -X POST http://localhost:5000/api/news \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "title": "RnApp Version 2.0 Released",
    "category": "news",
    "content": "We are excited to announce the release of RnApp v2.0 with new features...",
    "image": "https://example.com/image.jpg",
    "author": "Rn Team"
  }'
```

### Update News (Admin)

```bash
curl -X PUT http://localhost:5000/api/news/NEWS_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "title": "Updated Title"
  }'
```

### Delete News (Admin)

```bash
curl -X DELETE http://localhost:5000/api/news/NEWS_ID \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 5. Payments API

### Create Payment

```bash
curl -X POST http://localhost:5000/api/payments \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "amount": 50000,
    "method": "promptpay"
  }'
```

### Get All Payments (Admin)

```bash
curl http://localhost:5000/api/payments \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 6. Dashboard API

### Get Dashboard Stats (Admin)

```bash
curl http://localhost:5000/api/dashboard \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## Error Responses

### Unauthorized

```json
{
  "message": "Not authorized, no token"
}
```

### Access Denied

```json
{
  "message": "Access denied"
}
```

### Validation Error

```json
{
  "errors": [
    {
      "msg": "Name is required",
      "param": "name"
    }
  ]
}
```

## Tips

- Replace `YOUR_TOKEN_HERE` with actual token from login
- Replace `PROJECT_ID`, `CONTACT_ID`, etc. with actual IDs
- Use `jq` for pretty printing: `| jq`
- Save token in environment variable: `export TOKEN="your_token"`
- Then use: `curl ... -H "Authorization: Bearer $TOKEN"`
