import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arena_flow/features/auth/presentation/pages/login_page.dart';

void main() {
  testWidgets('LoginPage sanitization and accessibility widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    // 1. Verify Accessibility (Semantics) elements exist
    final emailField = find.bySemanticsLabel('Email Address Input Field');
    final pinField = find.bySemanticsLabel('PIN Code Input Field');
    final loginButton = find.bySemanticsLabel('Sign in to your account');
    
    expect(emailField, findsOneWidget);
    expect(pinField, findsOneWidget);
    expect(loginButton, findsOneWidget);
    
    // 2. Security Test: Input Injection Sanitization
    // Malicious injection attempt
    await tester.enterText(emailField, '<script>alert(1)</script>invalid@malicious.com');
    await tester.enterText(pinField, 'XOR1234');
    
    await tester.tap(loginButton);
    await tester.pumpAndSettle(); // Wait for state to rebuild
    
    // The regex sanitization should strip <> scripts and XOR string, triggering format error
    expect(find.text('Invalid email format.'), findsOneWidget);
  });
}
