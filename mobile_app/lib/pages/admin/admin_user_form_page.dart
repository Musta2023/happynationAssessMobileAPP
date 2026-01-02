import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/controllers/admin_users_controller.dart'; // To create/update users
import 'package:mobile_app/widgets/shared/back_and_home_buttons.dart';
import 'package:mobile_app/models/user.dart';

class AdminUserFormPage extends ConsumerStatefulWidget {
  final User? user; // Null if creating a new user

  const AdminUserFormPage({super.key, this.user});

  @override
  ConsumerState<AdminUserFormPage> createState() => _AdminUserFormPageState();
}

class _AdminUserFormPageState extends ConsumerState<AdminUserFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _departmentController;
  late String _selectedRole;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.user?.lastName ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _passwordController = TextEditingController(); // Passwords are not pre-filled
    _confirmPasswordController = TextEditingController();
    _departmentController = TextEditingController(text: widget.user?.department ?? '');
    _selectedRole = widget.user?.role ?? 'employee'; // Default role
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      ref.read(adminUsersProvider.notifier);

      String message = '';

      if (widget.user == null) {
        // Create new user (admin or employee)
        // Need a createUser method in AdminUsersNotifier
        // For now, let's assume register method for simplicity, but it should be an admin method
        // success = await notifier.createUser(data); // This method needs to be added to AdminUsersNotifier
        message = 'Create user functionality not yet fully implemented via admin panel.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      } else {
        // Update existing user (admin or employee)
        // Need an updateUser method in AdminUsersNotifier
        // success = await notifier.updateUser(widget.user!.id.toString(), data); // This method needs to be added
        message = 'Update user functionality not yet fully implemented via admin panel.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final adminUsersState = ref.watch(adminUsersProvider); // Used for loading/error state
    final isSaving = adminUsersState.isLoading; // Use isLoading from controller

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Create New User' : 'Edit User'),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: const [
          BackAndHomeButtons(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (widget.user == null && (value == null || value.isEmpty)) {
                    return 'Please enter a password';
                  }
                  if (value != null && value.isNotEmpty && value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (widget.user == null && (value == null || value.isEmpty)) {
                    return 'Please confirm your password';
                  }
                  if (_passwordController.text != value) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'Department'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: ['employee', 'admin'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a role';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving ? null : _submitForm,
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.user == null ? 'Create User' : 'Update User'),
                ),
              ),
              if (adminUsersState.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    adminUsersState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
