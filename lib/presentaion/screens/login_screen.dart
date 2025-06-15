// lib/screens/login_screen.dart
import 'package:firebase_demo_project/main.dart';
import 'package:firebase_demo_project/presentaion/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final authCtrl = Get.find<AuthController>();

  LoginScreen({
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
              decoration: InputDecoration(labelText: "Enter Email"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: "Enter Password"),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
                    Get.snackbar(
                      "Login Error!",
                      "Please fill all fields",
                      backgroundColor: Colors.red,
                    );
                    return;
                  }
                  if (passCtrl.text.length < 6) {
                    Get.snackbar("Login Error!",
                        "Password must be at least 6 characters",
                        backgroundColor: Colors.red, colorText: Colors.white);
                    return;
                  }

                  // Call the login method from AuthController
                  await authCtrl.login(emailCtrl.text, passCtrl.text);
                },
                child: Text("Sign In"),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // go to signup screen
                  await Get.to(SignUpScreen());
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
