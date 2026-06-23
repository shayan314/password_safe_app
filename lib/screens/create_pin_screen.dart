import 'package:flutter/material.dart';
import '../services/pin_service.dart';
import 'login_screen.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _savePin() async {
    final pin = pinController.text.trim();
    final confirmPin = confirmPinController.text.trim();

    // ❌ EMPTY CHECK
    if (pin.isEmpty || confirmPin.isEmpty) {
      _showMsg("Please enter and confirm PIN");
      return;
    }

    // ❌ NUMERIC ONLY CHECK
    if (!RegExp(r'^[0-9]+$').hasMatch(pin)) {
      _showMsg("PIN must contain only numbers");
      return;
    }

    // ❌ LENGTH CHECK
    if (pin.length < 4 || pin.length > 6) {
      _showMsg("PIN must be 4 to 6 digits");
      return;
    }

    // ❌ MATCH CHECK
    if (pin != confirmPin) {
      _showMsg("PIN does not match");
      return;
    }

    // ❌ WEAK PIN CHECK (optional but good)
    if (RegExp(r'^(.)\1+$').hasMatch(pin)) {
      _showMsg("Avoid weak PIN like 1111 or 0000");
      return;
    }

    // 💾 SAVE PIN
    await PinService.savePin(pin);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    pinController.dispose();
    confirmPinController.dispose();
    super.dispose();
  }

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

              Icon(
                Icons.lock_person,
                size: 90,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 20),

              Text(
                "Create Your PIN",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),

              const SizedBox(height: 25),

              // 🔢 PIN FIELD
              TextField(
                controller: pinController,
                obscureText: obscure1,
                keyboardType: TextInputType.number,
                maxLength: 6,

                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                ),

                decoration: InputDecoration(
                  counterText: "",
                  labelText: "Enter PIN",
                  filled: true,
                  fillColor: theme.cardColor,

                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure1 ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscure1 = !obscure1;
                      });
                    },
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🔢 CONFIRM PIN
              TextField(
                controller: confirmPinController,
                obscureText: obscure2,
                keyboardType: TextInputType.number,
                maxLength: 6,

                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                ),

                decoration: InputDecoration(
                  counterText: "",
                  labelText: "Confirm PIN",
                  filled: true,
                  fillColor: theme.cardColor,

                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure2 ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscure2 = !obscure2;
                      });
                    },
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔘 BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),

                  onPressed: _savePin,

                  child: const Text(
                    "Save PIN",
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