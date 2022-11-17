import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hush/create_password_page.dart';

class CreatePasswordPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: CreatePasswordPage(title: 'Title'),
    );
  }
}

void main() {
  group('CreatePassword Page', () {
    testWidgets('shows two text fields for password creation', (WidgetTester tester) async {
      await tester.pumpWidget(CreatePasswordPageWrapper());

      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('shows an OK button', (WidgetTester tester) async {
      await tester.pumpWidget(CreatePasswordPageWrapper());

      expect(find.byType(RaisedButton), findsOneWidget);
    });

    group('when entering blank password', () {
      testWidgets('shows error message', (WidgetTester tester) async {
        await tester.pumpWidget(CreatePasswordPageWrapper());

        Finder okButton = find.byType(RaisedButton);
        await tester.tap(okButton);
        await tester.pump();

        expect(find.text('Can\'t be blank'), findsOneWidget);
      });
    });

    group('when entering different passwords into the two tex fields', () {
      testWidgets('shows error message', (WidgetTester tester) async {
        await tester.pumpWidget(CreatePasswordPageWrapper());

        Finder textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), 'one');
        await tester.enterText(textFields.at(1), 'another');

        Finder okButton = find.byType(RaisedButton);
        await tester.tap(okButton);
        await tester.pump();

        expect(find.text('Passwords do not match'), findsOneWidget);
      });
    });
  });
}
