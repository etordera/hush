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

  setUpAll(() {
    tmpDir = Directory.systemTemp.createTempSync();
    var path = '${tmpDir.path}/secrets.hush';

    SecretsList secretsList = SecretsList(path: path, password: 'a password');
    Secret secretOne = Secret(name: 'Secret One');
    secretOne.properties['username'] = 'User Name One';
    secretOne.properties['password'] = 'Password One';
    secretOne.properties['notes'] = 'Notes One';
    secretsList.secrets.add(secretOne);
    secretsList.secrets.add(Secret(name: 'Secret Two'));
    secretsList.save();

    PathProviderPlatform.instance = MockPathProviderPlatform(path: tmpDir.path);
    disablePathProviderPlatformOverride = true;
  });

  tearDownAll(() {
    tmpDir.deleteSync(recursive: true);
  });

  group('Listing Page', () {
    testWidgets('shows a list of secrets', (WidgetTester tester) async {
      await tester.pumpWidget(ListingPageWrapper());

      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);

      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Secret One'), findsOneWidget);
      expect(find.text('Secret Two'), findsOneWidget);
    });

    group('when tapping on a secret in the list', () {
      testWidgets('navigates to selected secret form page', (WidgetTester tester) async {
        await tester.pumpWidget(ListingPageWrapper());

        await tester.pumpAndSettle(Duration(seconds: 5));

        await tester.tap(find.text('Secret One'));
        await tester.pumpAndSettle();

        expect(find.byType(SecretPage), findsOneWidget);
        expect(find.text('Secret One'), findsOneWidget);
        expect(find.text('User Name One'), findsOneWidget);
        expect(find.text('Password One'), findsOneWidget);
        expect(find.text('Notes One'), findsOneWidget);
      });
    });

    group('when tapping new secret button', () {
      testWidgets('navigates to new secret form page', (WidgetTester tester) async {
        await tester.pumpWidget(ListingPageWrapper());

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.byType(SecretPage), findsOneWidget);
      });
    });
  });
}
