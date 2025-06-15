import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_demo_project/presentaion/screens/login_screen.dart';
import 'package:firebase_demo_project/presentaion/screens/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      home: FirebaseAuth.instance.currentUser == null
          ? LoginScreen()
          : TaskScreen(),
    );
  }
}

// lib/controllers/auth_controller.dart
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

// lib/controllers/task_controller.dart
class TaskController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final tasks = <Map<String, dynamic>>[].obs;

  Future<void> fetchTasks() async {
    final querySnapshot = await _firestore.collection("tasks").get();
    tasks.assignAll(querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              'title': doc['title'],
            })
        .toList());
  }

  Future<bool> addTask(String title) async {
    try {
      await _firestore.collection("tasks").add({"title": title});
      fetchTasks();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateTask(String id, String newTitle) async {
    try {
      await _firestore.collection("tasks").doc(id).update({"title": newTitle});
      fetchTasks();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      await _firestore.collection("tasks").doc(id).delete();
      fetchTasks();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
