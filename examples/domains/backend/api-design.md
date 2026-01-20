# API Design Guidelines

## REST Conventions

### HTTP Methods
- `GET` - Retrieve resources (idempotent)
- `POST` - Create resources
- `PUT` - Replace resources (idempotent)
- `PATCH` - Partial update
- `DELETE` - Remove resources (idempotent)

### Status Codes
- `200` - Success
- `201` - Created
- `204` - No Content (successful DELETE)
- `400` - Bad Request (client error)
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `500` - Server Error

### URL Structure
```
GET    /users              # List users
GET    /users/:id          # Get single user
POST   /users              # Create user
PUT    /users/:id          # Replace user
PATCH  /users/:id          # Update user
DELETE /users/:id          # Delete user
GET    /users/:id/posts    # Nested resources
```

## Error Responses

Always return structured errors:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [
      { "field": "email", "message": "Email is required" }
    ]
  }
}
```

## Pagination

```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "per_page": 20,
    "total": 100,
    "total_pages": 5
  }
}
```

## Authentication

Use Bearer tokens in Authorization header:

```
Authorization: Bearer <token>
```

## Rate Limiting

Return rate limit headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640995200
```
