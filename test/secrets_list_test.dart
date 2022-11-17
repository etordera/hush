import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hush/secret.dart';
import 'package:hush/secrets_list.dart';

void main() {
  group('SecretsList', () {
    test('has a path, a password and a list of secrets', () {
      SecretsList secretsList = SecretsList(
        path: 'some_path',
        password: 'a_password'
      );

      expect(secretsList.path, 'some_path');
      expect(secretsList.password, 'a_password');

      var secrets = secretsList.secrets;
      expect(secrets.isEmpty, true);

      var secret = Secret(name: 'a secret');
      secrets.add(secret);
      expect(secrets.first, secret);
    });

    group('.save()', () {
      var tmpDir;

      setUp(() {
        tmpDir = Directory.systemTemp.createTempSync();
      });

      tearDown(() {
        tmpDir.deleteSync(recursive: true);
      });

      test('saves secrets list to defined path with encryption', () {
        var path = '${tmpDir.path}/secrets_file';
        SecretsList secretsList = SecretsList(
          path: path,
          password: 'a_password'
        );
        var secret = Secret(name: 'a secret');
        secret.set('username', 'michael');
        secret.set('password', 'jackson');
        secretsList.secrets.add(secret);

        secretsList.save();

        expect(File(path).existsSync(), true);
        var contents = File(path).readAsBytesSync();
        // TODO: Validar si açò funciona o no
        expect(contents.contains('a secret'), false);
        expect(contents.contains('username'), false);
        expect(contents.contains('michael'), false);
        expect(contents.contains('password'), false);
        expect(contents.contains('jackson'), false);
      });
    });

    group('.load()', () {
      var tmpDir;

      setUp(() {
        tmpDir = Directory.systemTemp.createTempSync();
      });

      tearDown(() {
        tmpDir.deleteSync(recursive: true);
      });

      test('loads secrets from defined path', () {
        var path = '${tmpDir.path}/secrets_file';
        var password = 'a_password';
        SecretsList secretsList = SecretsList(path: path, password: password);
        var secret = Secret(name: 'a secret');
        secret.set('a key', 'a value');
        secretsList.secrets.add(secret);
        secretsList.save();

        SecretsList loadedList = SecretsList(path: path, password: password);
        loadedList.load();

        expect(loadedList.secrets.isEmpty, false);
        var loadedSecret = loadedList.secrets.first;
        expect(loadedSecret.name, 'a secret');
        expect(loadedSecret.get('a key'), 'a value');
      });

      group('when source path does not exist', () {
        test('leaves secret list empty', () {
          var path = '${tmpDir.path}/nonexistent';
          var password = 'a_password';
          SecretsList loadedList = SecretsList(path: path, password: password);
          loadedList.load();

          expect(loadedList.secrets.isEmpty, true);
        });
      });
    });
  });
}
