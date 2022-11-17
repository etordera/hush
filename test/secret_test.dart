import 'package:flutter_test/flutter_test.dart';
import 'package:hush/secret.dart';

void main() {
  group('Secret', () {
    test('has a name', () {
      Secret secret = Secret(name: 'A name');
      expect(secret.name, 'A name');

      secret.name = 'Another name';
      expect(secret.name, 'Another name');
    });

    group('#set / #get', () {
      test('stores and retrieves values for arbitrary properties', () {
        Secret secret = Secret(name: 'A name');

        secret.set('some property', 'some value');
        expect(secret.get('some property'), 'some value');
      });
    });

    group('#delete', () {
      test('deletes stored properties', () {
        Secret secret = Secret(name: 'A name');
        secret.set('some property', 'some value');

        secret.delete('some property');
        expect(secret.get('some property'), null);
      });
    });
  });
}
