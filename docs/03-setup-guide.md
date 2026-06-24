# Setup Guide

## Prerequisites
- PHP 8.3+
- Composer
- Flutter 3.29+
- MySQL/MariaDB
- Node.js 18+

## Backend Setup
1. Clone repository
2. Copy .env.example to .env
3. Configure database credentials
4. Run `composer install`
5. Run `php artisan key:generate`
6. Run `php artisan jwt:secret`
7. Run `php artisan migrate`
8. Run `php artisan serve`

## Frontend Setup
1. Ensure Flutter SDK is installed
2. Run `flutter pub get`
3. Configure API URL in lib/core/constants/api_constants.dart
4. Run `flutter run`
