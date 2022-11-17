import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:hush/secret.dart';

class SecretsList {
  String path;
  String password;
  List<Secret> secrets = List<Secret>();

  SecretsList({this.path, this.password});

  void save() {
    var json = jsonEncode(this);
    var bytes = encrypt(json);
    var file = new File(path);
    file.writeAsBytesSync(bytes);
  }

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    for (var i = 0; i < secrets.length; i++) {
      var properties = {};
      secrets[i].properties.forEach((propName, value) {
        properties[propName] = value;
      });
      json[secrets[i].name] = properties;
    }
    return json;
  }

  void load() {
    var file = new File(path);
    if (!file.existsSync()) {
      return;
    }

    var bytes = file.readAsBytesSync();
    Map decoded = jsonDecode(decrypt(bytes));
    decoded.forEach((name, properties) {
      Secret secret = Secret(name: name);
      properties.forEach((propName, value) {
        secret.set(propName, value);
      });
      secrets.add(secret);
    });
  }

  List<int> encrypt(plainText) {
    var key = Key.fromUtf8(password);
    // TODO: Generar un salt aleatori i afegir-lo als bytes resultants
    key = key.stretch(16, iterationCount: 100, salt: Uint8List(16));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.ctr));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return iv.bytes + encrypted.bytes;
  }

  String decrypt(bytes) {
    var key = Key.fromUtf8(password);
    // TODO: Recuperar el salt aleatori dels bytes
    key = key.stretch(16, iterationCount: 100, salt: Uint8List(16));
    final iv = IV(bytes.sublist(0,15));
    final encrypter = Encrypter(AES(key, mode: AESMode.ctr));
    final encrypted = Encrypted(bytes.sublist(16));
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return decrypted;
  }
}