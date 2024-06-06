import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  // Email và password text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // Ấn để chuyển sang trang đăng nhập
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  // Register method
  Future<void> register(BuildContext context) async {
    // Get auth service
    final _auth = AuthService();

    // Lưu trữ parent context
    final parentContext = context;

    // Check if passwords match
    if (_pwController.text == _confirmPController.text) {
      try {
        // Pass username to signUpWithEmailPassword
        await _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
          _usernameController.text,
        );

        // Navigate to the next page after successful registration
        Navigator.pop(parentContext);
      } catch (e) {
        // Use a new build context for the dialog
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: parentContext,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
          );
        });
      }
    } else {
      // Use a new build context for the dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: parentContext,
          builder: (context) => const AlertDialog(
            title: Text("Passwords don't match!"),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.message_outlined,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 50),

              // Welcome back message
              Text(
                "Let's create an account for you!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // User name textfield
              MyTextField(
                hintText: "User name",
                obscureText: false,
                controller: _usernameController,
              ),

              const SizedBox(height: 10),

              // Email textfield
              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: _emailController,
              ),

              const SizedBox(height: 10),

              // Password textfield
              MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: _pwController,
              ),

              const SizedBox(height: 10),

              // Confirm password textfield
              MyTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: _confirmPController,
              ),

              const SizedBox(height: 25),

              // Register button
              MyButton(
                text: "Register",
                onTap: () => register(context),
              ),

              const SizedBox(height: 25),

              // Register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
