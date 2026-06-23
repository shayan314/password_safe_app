import 'package:flutter/material.dart';
import '../services/pin_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🔐 ICON
              Icon(
                Icons.lock,
                size: 90,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 20),

              // TITLE
              Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Enter your password to continue",
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),

              const SizedBox(height: 30),

              // PASSWORD FIELD
              TextField(
                controller: passwordController,
                obscureText: obscure,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                ),

                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: theme.textTheme.bodyMedium?.color,
                  ),

                  filled: true,
                  fillColor: theme.cardColor,

                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: theme.iconTheme.color,
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                      color: theme.iconTheme.color,
                    ),
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),

                  onPressed: () async {
                    final enteredPin = passwordController.text.trim();

                    if (enteredPin.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter PIN")),
                      );
                      return;
                    }

                    final isValid = await PinService.verifyPin(enteredPin);

                    if (!mounted) return;

                    if (isValid) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Incorrect PIN")),
                      );
                    }
                  },

                  child: const Text(
                    "Unlock",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}