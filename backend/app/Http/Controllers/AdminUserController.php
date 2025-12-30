<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

class AdminUserController extends Controller
{
    public function index()
    {
        // Fetch all users with their associated roles
        $users = User::all();

        return response()->json($users);
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'department' => 'required|string|max:255',
            'role' => ['required', 'string', Rule::in(['employee', 'admin'])],
        ]);

        $user = User::create([
            'first_name' => $validatedData['first_name'],
            'last_name' => $validatedData['last_name'],
            'name' => $validatedData['first_name'] . ' ' . $validatedData['last_name'], // Assuming 'name' field
            'email' => $validatedData['email'],
            'password' => Hash::make($validatedData['password']),
            'department' => $validatedData['department'],
            'role' => $validatedData['role'],
        ]);

        return response()->json($user, 201);
    }

    public function update(Request $request, User $user)
    {
        $validatedData = $request->validate([
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'email' => ['required', 'string', 'email', 'max:255', Rule::unique('users')->ignore($user->id)],
            'department' => 'required|string|max:255',
            'role' => ['required', 'string', Rule::in(['employee', 'admin'])],
            'password' => 'nullable|string|min:8|confirmed',
        ]);

        $user->update([
            'first_name' => $validatedData['first_name'],
            'last_name' => $validatedData['last_name'],
            'name' => $validatedData['first_name'] . ' ' . $validatedData['last_name'],
            'email' => $validatedData['email'],
            'department' => $validatedData['department'],
            'role' => $validatedData['role'],
        ]);

        if (isset($validatedData['password'])) {
            $user->password = Hash::make($validatedData['password']);
            $user->save();
        }

        return response()->json($user);
    }

    public function destroy(string $id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        if ($user->email === 'admin@company.com') { // Master admin protection
            return response()->json(['message' => 'Cannot delete the master admin account'], 403);
        }
        
        // Frontend uses user.id.toString(), so ensure comparison is correct
        // or ensure Master Admin has a fixed ID that is not deleted.
        // For now, email check is sufficient.

        $user->delete();

        return response()->json(['message' => 'User deleted successfully'], 200);
    }

    public function userResponses(string $id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        // Load responses with the user relationship
        $responses = $user->responses()->with(['user', 'items.question.assessments'])->latest()->get();

        return response()->json($responses);
    }

    public function getDepartments()
    {
        $departments = User::whereNotNull('department')->distinct()->pluck('department');
        return response()->json($departments);
    }
}
