# Room8 API Specification

## Base URL
```
https://api.room8.com/v1
```

## Authentication
All endpoints (except auth) require Bearer token:
```
Authorization: Bearer <token>
```

---

## 1. Authentication & Users

### POST /auth/register
Register a new user
```json
Request:
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phoneNumber": "+1234567890"
}

Response: 201
{
  "user": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john@example.com",
    "phoneNumber": "+1234567890"
  },
  "token": "jwt_token_here"
}
```

### POST /auth/login
Login existing user
```json
Request:
{
  "email": "john@example.com",
  "password": "password123"
}

Response: 200
{
  "user": { ... },
  "token": "jwt_token_here"
}
```

### GET /users/me
Get current user profile
```json
Response: 200
{
  "id": "uuid",
  "name": "John Doe",
  "email": "john@example.com",
  "phoneNumber": "+1234567890",
  "profileImageURL": "https://...",
  "householdID": "uuid"
}
```

### PUT /users/me
Update current user profile
```json
Request:
{
  "name": "John Smith",
  "phoneNumber": "+1234567890"
}

Response: 200
{ updated user object }
```

---

## 2. Households

### POST /households
Create a new household
```json
Request:
{
  "name": "Apartment 4B",
  "address": "123 Main St, City, State 12345"
}

Response: 201
{
  "id": "uuid",
  "name": "Apartment 4B",
  "address": "123 Main St",
  "memberIDs": ["creator_user_id"],
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### GET /households/:id
Get household details
```json
Response: 200
{
  "id": "uuid",
  "name": "Apartment 4B",
  "address": "123 Main St",
  "memberIDs": ["uuid1", "uuid2"],
  "members": [
    { "id": "uuid1", "name": "John", ... },
    { "id": "uuid2", "name": "Jane", ... }
  ],
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### POST /households/:id/join
Join a household (via invite code)
```json
Request:
{
  "inviteCode": "ABC123"
}

Response: 200
{ updated household object }
```

### POST /households/:id/leave
Leave a household
```json
Response: 204 No Content
```

---

## 3. Expenses

### GET /households/:householdId/expenses
Get all expenses for a household
```json
Query params: ?startDate=2024-01-01&endDate=2024-12-31&category=groceries

Response: 200
{
  "expenses": [
    {
      "id": "uuid",
      "title": "Groceries",
      "amount": 150.50,
      "category": "groceries",
      "paidByUserID": "uuid",
      "splitBetweenUserIDs": ["uuid1", "uuid2"],
      "date": "2024-01-15T10:30:00Z",
      "notes": "Costco run",
      "receiptImageURL": "https://...",
      "householdID": "uuid"
    }
  ],
  "total": 150.50
}
```

### POST /households/:householdId/expenses
Create a new expense
```json
Request:
{
  "title": "Groceries",
  "amount": 150.50,
  "category": "groceries",
  "paidByUserID": "uuid",
  "splitBetweenUserIDs": ["uuid1", "uuid2"],
  "date": "2024-01-15T10:30:00Z",
  "notes": "Costco run"
}

Response: 201
{ created expense object }
```

### PUT /expenses/:id
Update an expense
```json
Request:
{
  "title": "Updated title",
  "amount": 175.00
}

Response: 200
{ updated expense object }
```

### DELETE /expenses/:id
Delete an expense
```json
Response: 204 No Content
```

### GET /households/:householdId/expenses/balance
Get who owes whom
```json
Response: 200
{
  "balances": [
    {
      "userID": "uuid1",
      "userName": "John",
      "owes": 75.25,
      "owed": 50.00,
      "netBalance": -25.25
    },
    {
      "userID": "uuid2",
      "userName": "Jane",
      "owes": 50.00,
      "owed": 75.25,
      "netBalance": 25.25
    }
  ]
}
```

---

## 4. Chores

### GET /households/:householdId/chores
Get all chores for a household
```json
Query params: ?status=pending&assignedTo=uuid

Response: 200
{
  "chores": [
    {
      "id": "uuid",
      "title": "Take out trash",
      "description": "Trash day is Thursday",
      "assignedToUserID": "uuid",
      "dueDate": "2024-01-20T09:00:00Z",
      "isCompleted": false,
      "completedAt": null,
      "recurrence": "weekly",
      "householdID": "uuid"
    }
  ]
}
```

### POST /households/:householdId/chores
Create a new chore
```json
Request:
{
  "title": "Take out trash",
  "description": "Trash day is Thursday",
  "assignedToUserID": "uuid",
  "dueDate": "2024-01-20T09:00:00Z",
  "recurrence": "weekly"
}

Response: 201
{ created chore object }
```

### PUT /chores/:id
Update a chore
```json
Request:
{
  "title": "Updated title",
  "assignedToUserID": "different_uuid"
}

Response: 200
{ updated chore object }
```

### POST /chores/:id/complete
Mark chore as complete
```json
Response: 200
{
  "id": "uuid",
  "isCompleted": true,
  "completedAt": "2024-01-20T10:30:00Z",
  ...
}
```

### DELETE /chores/:id
Delete a chore
```json
Response: 204 No Content
```

---

## 5. Schedule Events

### GET /households/:householdId/events
Get all events for a household
```json
Query params: ?startDate=2024-01-01&endDate=2024-01-31

Response: 200
{
  "events": [
    {
      "id": "uuid",
      "title": "House meeting",
      "description": "Monthly household meeting",
      "startDate": "2024-01-15T19:00:00Z",
      "endDate": "2024-01-15T20:00:00Z",
      "createdByUserID": "uuid",
      "attendeeUserIDs": ["uuid1", "uuid2"],
      "location": "Living room",
      "householdID": "uuid"
    }
  ]
}
```

### POST /households/:householdId/events
Create a new event
```json
Request:
{
  "title": "House meeting",
  "description": "Monthly household meeting",
  "startDate": "2024-01-15T19:00:00Z",
  "endDate": "2024-01-15T20:00:00Z",
  "attendeeUserIDs": ["uuid1", "uuid2"],
  "location": "Living room"
}

Response: 201
{ created event object }
```

### PUT /events/:id
Update an event
```json
Request:
{
  "title": "Updated title",
  "startDate": "2024-01-15T20:00:00Z"
}

Response: 200
{ updated event object }
```

### DELETE /events/:id
Delete an event
```json
Response: 204 No Content
```

---

## Error Responses

All errors follow this format:
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": {}
  }
}
```

Common HTTP status codes:
- `400` - Bad Request (validation errors)
- `401` - Unauthorized (missing/invalid token)
- `403` - Forbidden (no permission)
- `404` - Not Found
- `500` - Internal Server Error

---

## Notes for Backend Developer

### Priority Endpoints (MVP)
1. **Auth**: Register, Login, Get User
2. **Households**: Create, Get, Join
3. **Expenses**: Create, List, Get Balance (most important feature!)
4. **Chores**: Create, List, Complete

### Nice to Have (Phase 2)
- Events/Schedule
- Image uploads (receipts, profile pictures)
- Push notifications
- Invite codes for households

### Database Schema Tips
- Use UUIDs for all IDs
- Index householdID on all main tables
- Add `createdAt` and `updatedAt` timestamps to all tables
- Consider soft deletes (deletedAt) instead of hard deletes
