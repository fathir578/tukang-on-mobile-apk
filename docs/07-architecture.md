# Architecture Overview

## System Design
- Mobile-first architecture
- RESTful API backend
- JWT-based stateless authentication

## Data Flow
1. User interacts with Flutter app
2. App sends HTTP requests to Laravel API
3. API processes requests and returns JSON
4. WhatsApp notifications sent via Fonnte API

## Security
- JWT token authentication
- Password hashing with bcrypt
- CORS configured for API
- Input validation on all endpoints
