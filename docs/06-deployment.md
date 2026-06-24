# Deployment Guide

## Server Requirements
- PHP 8.3+
- MySQL 8.0+ or MariaDB 10.5+
- Composer 2.x
- Node.js 18+

## Production Setup
1. Set APP_ENV=production in .env
2. Disable APP_DEBUG
3. Configure HTTPS
4. Set up queue worker
5. Configure cron for scheduler
