import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hush/secret.dart';

import 'package:hush/secret_page.dart';

class SecretPageWrapper extends StatelessWidget {
  final Secret secret;
  SecretPageWrapper({ Key key, this.secret }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SecretPage(secret: secret),
    );
  }
}

void main() async {
  group('Secret Page', () {
    group('when no secret is provided', () {
      testWidgets('shows a form for editing a new secret', (WidgetTester tester) async {
        await tester.pumpWidget(SecretPageWrapper());

        expect(find.widgetWithText(TextFormField, 'Name'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Username'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Notes'), findsOneWidget);
        expect(find.byType(RaisedButton), findsOneWidget);
      });
    });

    group('when a secret is provided', () {
      testWidgets('shows a form for editing provided secret with delete button', (WidgetTester tester) async {
        Secret secret = Secret(name: 'A secret');
        secret.properties['username'] = 'The username';
        secret.properties['password'] = 'The password';
        secret.properties['notes'] = 'The notes';
        await tester.pumpWidget(SecretPageWrapper(secret: secret));

        expect(find.widgetWithText(TextFormField, 'A secret'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'The username'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'The password'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'The notes'), findsOneWidget);
        expect(find.byType(RaisedButton), findsOneWidget);
        
        expect(find.byIcon(Icons.delete), findsOneWidget);
      });
    });
  });
}
