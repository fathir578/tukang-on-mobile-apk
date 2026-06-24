<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tukang', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->nullable()->unique();
            $table->string('phone')->nullable();
            $table->text('alamat')->nullable();
            $table->string('keahlian')->nullable();
            $table->string('foto')->nullable();
            $table->text('deskripsi')->nullable();
            $table->decimal('rating', 3, 2)->default(0);
            $table->string('status')->default('aktif');
            $table->foreignId('user_id')->nullable()->constrained()->onDelete('cascade');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tukang');
    }
};
