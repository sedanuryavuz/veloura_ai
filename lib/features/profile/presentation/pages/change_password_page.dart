import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloura_ai/features/auth/presentation/provider/auth_provider.dart';
import 'package:veloura_ai/features/auth/presentation/widgets/auth_button.dart';
import 'package:veloura_ai/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:veloura_ai/features/auth/presentation/widgets/auth_header.dart';
import 'package:veloura_ai/core/providers/language_provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(LanguageProvider lp) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Color(0xffE8B4B8)),
              const SizedBox(width: 10),
              Text(
                lp.translate('coming_soon'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            lp.translate('password_updated_success'),
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // pop dialog
                Navigator.of(context).pop(); // pop change password page
              },
              child: Text(
                lp.translate('ok'),
                style: const TextStyle(
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
    final lp = context.watch<LanguageProvider>();

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
                  AuthHeader(
                    title: lp.translate('change_password'),
                    subtitle: lp.translate('new_password'),
                  ),
                  const SizedBox(height: 50),
                  AuthTextField(
                    controller: passwordController,
                    hint: lp.translate('new_password'),
                    icon: Icons.lock_outline,
                    obscure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
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
                    hint: lp.translate('confirm_password'),
                    icon: Icons.lock_outline,
                    obscure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm password";
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
                    text: lp.translate('update_password').toUpperCase(),
                    isLoading: authProvider.isLoading,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await authProvider.updatePassword(
                          passwordController.text.trim(),
                        );
                        if (success && mounted) {
                          _showSuccessDialog(lp);
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
