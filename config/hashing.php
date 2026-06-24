<?php

return [
    'driver' => 'bcrypt',
    'bcrypt' => ['rounds' => env('BCRYPT_ROUNDS', 12)],
    'argon' => ['memory' => 65536, 'time' => 4, 'threads' => 1],
];
