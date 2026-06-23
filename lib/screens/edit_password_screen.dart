import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/password_model.dart';
import '../providers/password_provider.dart';
import '../services/encryption_service.dart';

class EditPasswordScreen extends StatefulWidget {
  final PasswordModel item;

  const EditPasswordScreen({super.key, required this.item});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController accountController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  bool obscure = true;

  @override
  void initState() {
    super.initState();

    accountController = TextEditingController(text: widget.item.account);
    usernameController = TextEditingController(text: widget.item.username);

    // decrypt old password for editing
    passwordController = TextEditingController(
      text: EncryptionService.decryptPassword(widget.item.password),
    );
  }

  @override
  void dispose() {
    accountController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PasswordProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Password"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              TextFormField(
                controller: accountController,
                decoration: const InputDecoration(labelText: "Account"),
                validator: (v) =>
                v == null || v.isEmpty ? "Enter account" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (v) =>
                v == null || v.isEmpty ? "Enter username" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: passwordController,
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                  ),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Enter password" : null,
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final updatedModel = PasswordModel(
                    id: widget.item.id, // 🔴 IMPORTANT FIX
                    account: accountController.text.trim(),
                    username: usernameController.text.trim(),
                    password: EncryptionService.encryptPassword(
                      passwordController.text.trim(),
                    ),
                  );

                  await provider.updatePassword(updatedModel);
                  await provider.loadPasswords();

                  if (mounted) Navigator.pop(context);
                },
                child: const Text("Update Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}