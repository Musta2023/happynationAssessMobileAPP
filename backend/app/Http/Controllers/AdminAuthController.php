<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AdminAuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if ($user && Hash::check($request->password, $user->password)) {
            if ($user->role === 'admin') {
                $tokenResult = $user->createToken('AdminToken');
                $token = $tokenResult->accessToken;
                
                return response()->json([
                    'token' => $token,
                    'user' => $user
                ], 200);
            }
        }

        return response()->json(['message' => 'Invalid credentials or user is not an admin'], 401);
    }
}