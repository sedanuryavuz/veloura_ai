import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/auth_header.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
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
                "Check Your Inbox",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            "If an account exists for this email, a password reset link has been sent. Please check your inbox.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // pop dialog
                Navigator.of(context).pop(); // navigate back to login page
              },
              child: const Text(
                "Back to Login",
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xff2D3436)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const AuthHeader(
                    title: "Forgot Password",
                    subtitle: "Get a link to regain access to your account",
                  ),
                  const SizedBox(height: 50),
                  AuthTextField(
                    controller: emailController,
                    hint: "Email Address",
                    icon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your email";
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return "Please enter a valid email address";
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
                    text: "SEND RESET LINK",
                    isLoading: authProvider.isLoading,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await authProvider.sendPasswordResetEmail(
                          emailController.text.trim(),
                        );
                        if (success && mounted) {
                          _showSuccessDialog();
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Remembered your password? ",
                        style: TextStyle(color: const Color(0xff2D3436).withOpacity(0.6)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Back to Login",
                          style: TextStyle(
                            color: Color(0xffE8B4B8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
