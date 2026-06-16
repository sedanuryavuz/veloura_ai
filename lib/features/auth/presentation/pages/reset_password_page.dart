import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/auth_header.dart';
import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Color(0xffE8B4B8)),
              SizedBox(width: 10),
              Text(
                "Password Updated",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            "Your password has been successfully reset. Please log in with your new password.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // pop dialog
                final authProvider = context.read<AuthProvider>();
                await authProvider.logout(); // clear recovery session
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              child: const Text(
                "Go to Login",
                style: TextStyle(
                  color: Color(0xffE8B4B8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffFDFBFB),
              Color(0xffEBEDEE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const AuthHeader(
                    title: "Reset Password",
                    subtitle: "Set a secure new password for your account",
                  ),
                  const SizedBox(height: 50),
                  AuthTextField(
                    controller: passwordController,
                    hint: "New Password",
                    icon: Icons.lock_outline,
                    obscure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a new password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: confirmPasswordController,
                    hint: "Confirm New Password",
                    icon: Icons.lock_outline,
                    obscure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  if (authProvider.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        authProvider.error!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  AuthButton(
                    text: "RESET PASSWORD",
                    isLoading: authProvider.isLoading,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await authProvider.updatePassword(
                          passwordController.text.trim(),
                        );
                        if (success && mounted) {
                          _showSuccessDialog();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
