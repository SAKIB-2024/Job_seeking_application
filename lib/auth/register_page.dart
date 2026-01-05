import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final supabase = Supabase.instance.client;

  String? _selectedRole;
  bool _showPassword = false;
  bool _isLoading = false;

  // Validators
  bool isValidEmail(String email) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

  bool isStrongPassword(String password) =>
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$')
          .hasMatch(password);

  Widget roleOption(String role, IconData icon) {
    final bool isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color.fromARGB(255, 38, 49, 36) : Colors.grey,
            width: 2,
          ),
          color: isSelected ? const Color.fromARGB(255, 38, 49, 36).withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color.fromARGB(255, 38, 49, 36) : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                role,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? const Color.fromARGB(255, 38, 49, 36) : Colors.black,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color.fromARGB(255, 38, 49, 36)),
          ],
        ),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    ));
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> register() async {
    final username = _username.text.trim();
    final email = _email.text.trim();
    final password = _password.text;
    final confirmPassword = _confirmPassword.text;

    // Validation
    if (username.isEmpty) return _showError("Username is required");
    if (email.isEmpty) return _showError("Email is required");
    if (!isValidEmail(email)) return _showError("Enter a valid email");
    if (password.isEmpty) return _showError("Password is required");
    if (!isStrongPassword(password)) return _showError(
        "Password must be 8+ chars, include uppercase, lowercase, number & special char");
    if (confirmPassword.isEmpty) return _showError("Confirm your password");
    if (password != confirmPassword) return _showError("Passwords do not match");
    if (_selectedRole == null) return _showError("Please select a role");

    setState(() => _isLoading = true);
    
    try {
      // Sign up the user
      final AuthResponse res = await supabase.auth.signUp(
        email: _email.text.trim(),
        password: _password.text,
        data: {
          'name': _username.text.trim(),
          'role': _selectedRole,
        },
      );
      
      if (res.user == null) {
        throw Exception('User creation failed');
      }
      
      // Show success message
      _showSuccess('Registration successful! Please login.');
      
      // Go back to login
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) Navigator.pop(context);
      
    } on AuthException catch (e) {
      _showError("Authentication Error: ${e.message}");
    } on PostgrestException catch (e) {
      _showError("Database Error: ${e.message}");
    } catch (e) {
      _showError("Error: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: const Color.fromARGB(255, 38, 49, 36),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username Field
              TextField(
                controller: _username,
                decoration: const InputDecoration(
                  labelText: "Username *",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              
              // Email Field
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: "Email *",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              
              // Password Field
              TextField(
                controller: _password,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: "Password *",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Confirm Password Field
              TextField(
                controller: _confirmPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password *",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 20),
              
              // Role Selection Title
              const Text(
                "Select Role *",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              // Role Options
              roleOption("Job Seeker", Icons.person),
              roleOption("Employer", Icons.business),
              roleOption("Admin", Icons.admin_panel_settings),
              const SizedBox(height: 20),
              
              // Register Button
              ElevatedButton(
                onPressed: _isLoading ? null : register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 38, 49, 36),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              
              // Back to Login Button
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text(
                  "Back to Login",
                  style: TextStyle(color: Color.fromARGB(255, 38, 49, 36)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }
}