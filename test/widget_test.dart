// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_demo_project/presentaion/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// test/unit_tests.dart
void main() {
  testWidgets('Login screen has email and password fields', (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
