import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final secretKey = dotenv.env['ENCRYPTION_SECRET_KEY'] ?? '';
final secretIv = dotenv.env['ENCRYPTION_IV'] ?? '';

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
