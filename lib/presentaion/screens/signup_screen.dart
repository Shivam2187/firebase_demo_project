// lib/screens/login_screen.dart
import 'package:firebase_demo_project/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final authCtrl = Get.find<AuthController>();

  SignUpScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: "Enter new Email"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: "Enter new Password"),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
                    Get.snackbar(
                      "Signup Error",
                      "Please fill all fields",
                      backgroundColor: Colors.red,
                    );
                    return;
                  }
                  if (passCtrl.text.length < 6) {
                    Get.snackbar(
                      "Signup Error",
                      "Password must be at least 6 characters",
                      backgroundColor: Colors.red,
                    );
                    return;
                  }
                  // Call the createUser method from AuthController
                  authCtrl.createUser(emailCtrl.text, passCtrl.text);
                },
                child: Text("Sign Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
