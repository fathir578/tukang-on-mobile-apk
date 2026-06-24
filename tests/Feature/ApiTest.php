<?php

namespace Tests\Feature;

use Tests\TestCase;

class ApiTest extends TestCase
{
    public function test_login_endpoint_returns_validation_error(): void
    {
        $response = $this->postJson('/api/login', []);
        $response->assertStatus(422);
    }

    public function test_tukang_list_is_accessible(): void
    {
        $response = $this->getJson('/api/tukang');
        $response->assertStatus(200);
    }
}
