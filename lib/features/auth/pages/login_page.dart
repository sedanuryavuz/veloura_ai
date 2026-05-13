import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloura_ai/features/chat/pages/chat_page.dart';

import '../controllers/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xffF4F1F2),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Text(
                "Veloura",
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 10),

              const Text("Your digital wardrobe"),

              const SizedBox(height: 50),

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
                      text: "Login",

                      onTap: () async {
                        final success = await controller.login(
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        if (success && mounted) {
                          Navigator.pushReplacement(
                            context,

                            MaterialPageRoute(builder: (_) => const ChatPage()),
                          );
                        }
                      },
                    ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },

                child: const Text("Create account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
