<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        User::create([
            'name' => 'Admin',
            'email' => 'admin@tukangon.com',
            'password' => bcrypt('password123'),
            'role' => 'admin',
        ]);

        User::create([
            'name' => 'Budi Tukang Listrik',
            'email' => 'budi@tukangon.com',
            'password' => bcrypt('password123'),
            'role' => 'tukang',
            'phone' => '08123456789',
            'alamat' => 'Jl. Merdeka No. 1, Jakarta',
        ]);

        User::create([
            'name' => 'User Biasa',
            'email' => 'user@tukangon.com',
            'password' => bcrypt('password123'),
            'role' => 'user',
            'phone' => '08765432100',
            'alamat' => 'Jl. Sudirman No. 10, Jakarta',
        ]);
    }
}
