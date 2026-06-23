import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Settings"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // 🌙 DARK MODE SWITCH (REAL FUNCTIONAL)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),

            child: SwitchListTile(
              value: themeProvider.isDark,

              onChanged: (value) {
                themeProvider.toggleTheme();
              },

              activeColor: const Color(0xFF6C63FF),

              title: const Text(
                "Dark Mode",
                style: TextStyle(color: Colors.white),
              ),

              secondary: const Icon(
                Icons.dark_mode,
                color: Colors.white70,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ℹ️ ABOUT SECTION (IMPROVED BUT SAME DESIGN)
          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "About App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Password Safe is a secure offline password manager built using Flutter. "
                      "It uses SQLite for local storage and AES encryption to protect your data.",
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Version: 1.0.0",
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}