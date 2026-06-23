import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/password_model.dart';
import '../providers/password_provider.dart';
import '../services/encryption_service.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({super.key});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final accountController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    accountController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<PasswordProvider>(context, listen: false);

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Add Password"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              // 🔹 ACCOUNT
              TextFormField(
                controller: accountController,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                ),

                decoration: InputDecoration(
                  labelText: "Account Name",
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter account name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // 🔹 USERNAME
              TextFormField(
                controller: usernameController,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                ),

                decoration: InputDecoration(
                  labelText: "Username / Email",
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter username";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // 🔹 PASSWORD
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,

                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                ),

                decoration: InputDecoration(
                  labelText: "Password",
                  filled: true,
                  fillColor: theme.cardColor,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: theme.iconTheme.color,
                      size: 20,
                    ),

                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter password";
                  }
                  if (value.length < 4) {
                    return "Password too short";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              // 🔹 SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    theme.colorScheme.primary,
                  ),

                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final model = PasswordModel(
                        account: accountController.text.trim(),
                        username: usernameController.text.trim(),
                        password: EncryptionService.encryptPassword(
                          passwordController.text.trim(),
                        ),
                      );

                      await provider.addPassword(model);

                      if (mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },

                  child: const Text(
                    "Save Password",
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