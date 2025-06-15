// lib/screens/login_screen.dart
import 'package:firebase_demo_project/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final authCtrl = Get.find<AuthController>();

  SignUpScreen({
    super.key,
  });
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // add validation to the email and password fields
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      labelText: "Enter new Email",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      // Add more validation if needed
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration:
                        InputDecoration(labelText: "Enter new Password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      // Add more validation if needed
                      return null;
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Call the createUser method from AuthController
                  if (_formKey.currentState!.validate()) {
                    authCtrl.createUser(emailCtrl.text, passCtrl.text);
                  }
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
