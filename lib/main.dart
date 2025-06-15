import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_demo_project/controllers/auth_controller.dart';
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
