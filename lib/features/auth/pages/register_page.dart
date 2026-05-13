import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloura_ai/features/auth/pages/login_page.dart';

import '../controllers/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xffF4F1F2),

      appBar: AppBar(backgroundColor: Colors.transparent),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Text(
              "Create Account",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 40),

            AuthTextField(controller: emailController, hint: "Email"),

            const SizedBox(height: 16),

            AuthTextField(
              controller: passwordController,
              hint: "Password",
              obscure: true,
            ),

            const SizedBox(height: 24),

            controller.isLoading
                ? const CircularProgressIndicator()
                : AuthButton(
                    text: "Register",

                    onTap: () async {
                      final success = await controller.register(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Account created")),
                        );

                        Navigator.pushReplacement(
                          context,

                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
