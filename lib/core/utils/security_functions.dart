import 'package:encrypt/encrypt.dart';
import 'package:living_way/core/config/env.dart';

//Encryption function used for hiding the content in a message
String encrypt(String text) {
  final key = Key.fromUtf8(secretKey);
  final iv = IV.fromUtf8(secretIv);

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(text, iv: iv);

  return encrypted.base16;
}

//Decryption function used for revealing the content in a message
String decrypt(String text) {
  final key = Key.fromUtf8(secretKey);
  final iv = IV.fromUtf8(secretIv);

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final decrypted = encrypter.decrypt(Encrypted.fromBase16(text), iv: iv);

  return decrypted;
}
