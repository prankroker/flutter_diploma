import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_diploma/views/screens/mainPage.dart';

void main() {
  testWidgets('На головному екрані мають бути присутні всі UI елементи', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainPage(),
      ),
    );
    expect(find.text('Англійська мова'), findsOneWidget);
    expect(find.text('Німецька мова'), findsOneWidget);
    expect(find.text('Чат-бот'),findsOneWidget);

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.book), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}