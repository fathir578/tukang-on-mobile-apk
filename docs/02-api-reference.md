# API Reference

## Base URL
```
http://localhost:8000/api
```

## Authentication
- Method: JWT Bearer Token
- Header: `Authorization: Bearer <token>`

## Endpoints

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/login | Login user |
| POST | /api/register | Register user |
| GET | /api/me | Get profile |
| POST | /api/logout | Logout |
| POST | /api/refresh | Refresh token |
| PUT | /api/profile | Update profile |

### Tukang
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/tukang | List tukang |
| GET | /api/tukang/:id | Detail tukang |
| POST | /api/tukang | Create tukang |
| PUT | /api/tukang/:id | Update tukang |
| DELETE | /api/tukang/:id | Delete tukang |

### Orders
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/orders | List orders |
| POST | /api/orders | Create order |
| GET | /api/orders/:id | Detail order |
| POST | /api/orders/:id/process | Process order |
| POST | /api/orders/:id/complete | Complete order |
| POST | /api/orders/:id/cancel | Cancel order |

### Ratings
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/ratings | Create rating |

### Dashboard
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/dashboard | Admin stats |
