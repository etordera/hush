import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hush/password_page.dart';

class PasswordPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: PasswordPage(title: 'Title'),
    );
  }
}

void main() {
  group('Password Page', () {
    testWidgets('shows a text field for the password', (WidgetTester tester) async {
      await tester.pumpWidget(PasswordPageWrapper());

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('shows an OK button', (WidgetTester tester) async {
      await tester.pumpWidget(PasswordPageWrapper());

      expect(find.byType(RaisedButton), findsOneWidget);
    });

    group('when entering blank password', () {
      testWidgets('shows error message', (WidgetTester tester) async {
        await tester.pumpWidget(PasswordPageWrapper());

        Finder okButton = find.byType(RaisedButton);
        await tester.tap(okButton);
        await tester.pump();

        expect(find.text('Can\'t be blank'), findsOneWidget);
      });
    });
  });
}
