import 'package:flutter/material.dart';
import 'package:flutter_diploma/views/screens/auth/registrationPage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_diploma/views/screens/auth/loginPage.dart';
import 'package:flutter_diploma/views/screens/mainPage.dart';
import 'package:flutter_diploma/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Тестування автентифікації', () {
    testWidgets('Невірні дані', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(Login), findsOneWidget);

      final emailField = find.byKey(const ValueKey('email_field'));
      final passwordField = find.byKey(const ValueKey('password_field'));

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      await tester.tap(find.text('Далі'));
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 1));

      expect(find.text('Неправильний пароль або пошта'), findsOneWidget);
    });
    testWidgets('Вірні дані', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(Login), findsOneWidget);

      final emailField = find.byKey(const ValueKey('email_field'));
      final passwordField = find.byKey(const ValueKey('password_field'));

      await tester.enterText(emailField, 'tester1@gmail.com');
      await tester.enterText(passwordField, 'tester1');

      await tester.tap(find.text('Далі'));
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 1));

      expect(find.byType(MainPage), findsOneWidget);
    });
  });

  group('Тестування реєстрації', () {
    testWidgets('Невірні дані', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      
      expect(find.byType(Login), findsOneWidget);
      
      await tester.tap(find.text(' Зареєструйтеся'));

      await Future.delayed(const Duration(seconds: 2));

      expect(find.byType(Registration), findsOneWidget);

      final username = find.byKey(const ValueKey('username'));
      final emailField = find.byKey(const ValueKey('email_field'));
      final passwordField = find.byKey(const ValueKey('password_field'));

      await tester.enterText(username, 'username');
      await tester.enterText(emailField, '');
      await tester.enterText(passwordField, '');

      await tester.tap(find.text('Далі'));
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 1));

      expect(find.text('пошта або пароль не мають бути пусті'), findsOneWidget);
    });
  });
}