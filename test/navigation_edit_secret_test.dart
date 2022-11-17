import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hush/listing_page.dart';
import 'package:hush/secret.dart';
import 'package:hush/secret_page.dart';
import 'package:hush/secrets_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'mock_path_provider_platform.dart';

class ListingPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListingPage(),
    );
  }
}

void main() async {
  var tmpDir;
  var tmpSecretsPath;

  group('Navigation for secrets editing', () {
    setUpAll(() {
      tmpDir = Directory.systemTemp.createTempSync();
      tmpSecretsPath = '${tmpDir.path}/secrets.hush';

      PathProviderPlatform.instance = MockPathProviderPlatform(path: tmpDir.path);
      disablePathProviderPlatformOverride = true;
    });

    tearDownAll(() {
      tmpDir.deleteSync(recursive: true);
    });

    setupSecretsList() {
      SecretsList secretsList = SecretsList(path: tmpSecretsPath, password: 'a password');
      Secret secretOne = Secret(name: 'Secret One');
      secretOne.properties['username'] = 'User Name One';
      secretOne.properties['password'] = 'Password One';
      secretOne.properties['notes'] = 'Notes One';
      secretsList.secrets.add(secretOne);
      secretsList.save();
    }

    group('when editing an existing secret', () {
      testWidgets('secret is updated in the list and stored', (WidgetTester tester) async {
        setupSecretsList();

        await tester.pumpWidget(ListingPageWrapper());
        await tester.pumpAndSettle(Duration(seconds: 5));

        await tester.tap(find.text('Secret One'));
        await tester.pumpAndSettle();

        expect(find.byType(SecretPage), findsOneWidget);
        await tester.enterText(find.widgetWithText(TextFormField, 'Secret One'), 'Updated Name');
        await tester.enterText(find.widgetWithText(TextFormField, 'User Name One'), 'Updated Username');
        await tester.enterText(find.widgetWithText(TextFormField, 'Password One'), 'Updated Password');
        await tester.enterText(find.widgetWithText(TextFormField, 'Notes One'), 'Updated Notes');

        await tester.tap(find.byType(RaisedButton));
        await tester.pumpAndSettle();

        expect(find.byType(ListingPage), findsOneWidget);
        expect(find.text('Secret One'), findsNothing);
        expect(find.text('Updated Name'), findsOneWidget);

        await tester.tap(find.text('Updated Name'));
        await tester.pumpAndSettle();

        expect(find.byType(SecretPage), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Updated Name'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Updated Username'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Updated Password'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Updated Notes'), findsOneWidget);

        var path = '${tmpDir.path}/secrets.hush';
        SecretsList secretsList = SecretsList(path: path, password: 'a password');
        secretsList.load();
        Secret secret = secretsList.secrets.singleWhere((secret) => secret.name == 'Updated Name');
        expect(secret.properties['username'], 'Updated Username');
        expect(secret.properties['password'], 'Updated Password');
        expect(secret.properties['notes'], 'Updated Notes');
      });
    });

    group('when creating a new secret', () {
      testWidgets('new secret is added to the list and stored', (WidgetTester tester) async {
        await tester.pumpWidget(ListingPageWrapper());

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.byType(SecretPage), findsOneWidget);

        await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'New Name');
        await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'New Username');
        await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'New Password');
        await tester.enterText(find.widgetWithText(TextFormField, 'Notes'), 'New Notes');
        await tester.tap(find.byType(RaisedButton));

        await tester.pumpAndSettle();
        expect(find.byType(ListingPage), findsOneWidget);

        await tester.tap(find.text('New Name'));
        await tester.pumpAndSettle();

        expect(find.byType(SecretPage), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'New Name'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'New Username'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'New Password'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'New Notes'), findsOneWidget);

        var path = '${tmpDir.path}/secrets.hush';
        SecretsList secretsList = SecretsList(path: path, password: 'a password');
        secretsList.load();
        Secret secret = secretsList.secrets.singleWhere((secret) => secret.name == 'New Name');
        expect(secret.properties['username'], 'New Username');
        expect(secret.properties['password'], 'New Password');
        expect(secret.properties['notes'], 'New Notes');
      });
    });

    group('when editing and deleting an existing secret', () {
      testWidgets('secret is removed from the list and storage', (WidgetTester tester) async {
        setupSecretsList();

        await tester.pumpWidget(ListingPageWrapper());
        await tester.pumpAndSettle(Duration(seconds: 5));

        await tester.tap(find.text('Secret One'));
        await tester.pumpAndSettle();

        expect(find.byType(SecretPage), findsOneWidget);
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        expect(find.byType(ListingPage), findsOneWidget);
        expect(find.text('Secret One'), findsNothing);

        var path = '${tmpDir.path}/secrets.hush';
        SecretsList secretsList = SecretsList(path: path, password: 'a password');
        secretsList.load();
        expect(secretsList.secrets.length, 0);
      });
    });
  });
}
