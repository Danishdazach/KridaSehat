import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final usernameController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    String username = usernameController.text;

    // Here you would handle the password reset request.
    // For example, make an API call to send a password reset email.

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password reset link sent to $username'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back to the login page after password reset request
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Password'),
        backgroundColor: const Color(0xFF6E7E40),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          children: [
            const Text(
              'Masukkan username Anda untuk menerima link reset password.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF6E7E40), width: 1.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6E7E40),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Kirim Link Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
