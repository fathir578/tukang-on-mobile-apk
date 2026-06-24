# Tukang-On

Aplikasi mobile untuk mencari dan memesan tukang servis terpercaya di sekitar Anda.

## Fitur

- Cari tukang berdasarkan keahlian dan lokasi
- Pesan jasa tukang online
- Beri rating dan review setelah servis selesai
- Notifikasi WhatsApp untuk update status pesanan
- Dashboard admin untuk manajemen tukang
- Autentikasi JWT yang aman

## Arsitektur

| Komponen | Teknologi |
|----------|-----------|
| Frontend Mobile | Flutter 3.29.2 |
| Backend API | Laravel 13 |
| Database | MySQL / MariaDB |
| Autentikasi | JWT (tymon/jwt-auth) |
| Notifikasi | WhatsApp API (Fonnte) |

## Entity Relationship Diagram

```mermaid
erDiagram
    users ||--o{ orders : "memesan"
    users ||--o{ ratings : "memberi"
    users ||--o{ tukang : "mengelola"
    tukang ||--o{ orders : "dipesan"
    tukang ||--o{ ratings : "dinilai"
    orders ||--o| ratings : "memiliki"

    users {
        bigint id PK
        string name
        string email UK
        timestamp email_verified_at
        string password
        string role
        string phone
        text alamat
        string foto
        timestamp created_at
        timestamp updated_at
    }

    tukang {
        bigint id PK
        string name
        string email UK
        string phone
        text alamat
        string keahlian
        string foto
        text deskripsi
        decimal rating
        string status
        bigint user_id FK
        timestamp created_at
        timestamp updated_at
    }

    orders {
        bigint id PK
        bigint user_id FK
        bigint tukang_id FK
        text deskripsi
        text alamat
        string status
        timestamp diproses_at
        timestamp selesai_at
        timestamp created_at
        timestamp updated_at
    }

    ratings {
        bigint id PK
        bigint user_id FK
        bigint tukang_id FK
        bigint order_id FK
        int rating
        text review
        timestamp created_at
        timestamp updated_at
    }
```

## Branch

| Branch | Isi |
|--------|-----|
| `main` | Dokumentasi + Flutter + Laravel |
| `mobile` | Aplikasi Flutter |
| `backend` | REST API Laravel |

## Cara Menjalankan

### Backend

```bash
cd backend
cp .env.example .env
# isi config database dan JWT
composer install
php artisan migrate
php artisan serve --host=0.0.0.0 --port=8000
```

### Frontend (Mobile)

```bash
# setup environment
source env.sh
flutter pub get
flutter run
```

## Lisensi

Hak cipta dilindungi undang-undang.
