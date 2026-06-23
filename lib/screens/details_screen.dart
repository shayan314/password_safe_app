import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'edit_password_screen.dart';
import '../models/password_model.dart';
import '../providers/password_provider.dart';
import '../services/encryption_service.dart';

class DetailsScreen extends StatelessWidget {
  final PasswordModel item;

  const DetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<PasswordProvider>(context, listen: false);

    final theme = Theme.of(context);

    final decryptedPassword =
    EncryptionService.decryptPassword(item.password);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Password Details"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            _buildCard(
              context,
              title: "Account",
              value: item.account,
              icon: Icons.lock,
            ),

            const SizedBox(height: 12),

            _buildCard(
              context,
              title: "Username",
              value: item.username,
              icon: Icons.person,
            ),

            const SizedBox(height: 12),

            _buildCard(
              context,
              title: "Password",
              value: decryptedPassword,
              icon: Icons.key,
              showCopy: true,
              onCopy: () {
                Clipboard.setData(
                  ClipboardData(text: decryptedPassword),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Password Copied!"),
                  ),
                );
              },
            ),

            const Spacer(),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4A460),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPasswordScreen(item: item),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text(
                  "Edit Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // 🧹 DELETE BUTTON (THEMED)
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),

                onPressed: () async {
                  await provider.deletePassword(item.id!);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },

                icon: const Icon(Icons.delete),
                label: const Text(
                  "Delete Password",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📦 REUSABLE CARD WIDGET (THEME READY)
  Widget _buildCard(
      BuildContext context, {
        required String title,
        required String value,
        required IconData icon,
        bool showCopy = false,
        VoidCallback? onCopy,
      }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color: theme.colorScheme.primary,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          if (showCopy)
            IconButton(
              onPressed: onCopy,
              icon: Icon(
                Icons.copy,
                color: theme.iconTheme.color,
              ),
            ),
        ],
      ),
    );
  }
}