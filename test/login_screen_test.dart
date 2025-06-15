import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_project/presentaion/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:firebase_demo_project/controllers/auth_controller.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

class MockAuthController extends GetxService implements AuthController {
  @override
  Future<void> login(String email, String password) async {
    // fake login logic for test
  }

  @override
  Disposer addListener(GetStateUpdate listener) {
    throw UnimplementedError();
  }

  @override
  Disposer addListenerId(Object? key, GetStateUpdate listener) {
    throw UnimplementedError();
  }

  @override
  Future<void> createUser(String email, String password) {
    throw UnimplementedError();
  }

  @override
  void dispose() {}

  @override
  void disposeId(Object id) {}

  @override
  Rx<User?> get firebaseUser => throw UnimplementedError();

  @override
  bool get hasListeners => throw UnimplementedError();

  @override
  int get listeners => throw UnimplementedError();

  @override
  void notifyChildrens() {}

  @override
  void refresh() {}

  @override
  void refreshGroup(Object id) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  void removeListenerId(Object id, VoidCallback listener) {}

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {}
}

void main() {
  setUp(() {
    Get.put<AuthController>(MockAuthController());
  });

  testWidgets('LoginScreen UI renders and form validates',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(home: LoginScreen()),
    );

    // Check heading text
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Login to continue'), findsOneWidget);

    // Check form fields
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);

    // Enter invalid email
    await tester.enterText(find.byType(TextFormField).first, 'invalidemail');
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);

    // Enter valid email and short password
    await tester.enterText(
        find.byType(TextFormField).first, 'user@example.com');
    await tester.enterText(find.byType(TextFormField).last, '123');
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });
}
