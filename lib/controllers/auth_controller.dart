// lib/controllers/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_project/presentaion/screens/login_screen.dart';
import 'package:firebase_demo_project/presentaion/screens/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<void> createUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.offAll(() => TaskScreen());
      Get.snackbar("Signup Successful", "Welcome",
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Signup Failed", e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => TaskScreen());
      Get.snackbar("Login Successful", "Welcome Back",
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("User Not Found", e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar("Sign Out Failed", e.toString(),
          backgroundColor: Colors.red);
    }
  }
}
