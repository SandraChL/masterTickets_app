import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';

String encryptQueryParams(String title, String date, String location) {
  final plainText = 'titulo=$title&fecha=$date&ubicacion=$location';

  // Clave de 32 caracteres (AES-256)
  final key = encrypt.Key.fromUtf8('12345678901234567890123456789012'); 
  final iv = encrypt.IV.fromLength(16); // Vector de inicialización

  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypter.encrypt(plainText, iv: iv);

  return encrypted.base64;
}




class CryptoHelper {
  static final _key = Key.fromUtf8('12345678901234567890123456789012'); // 32 chars
  static final _iv = IV.fromUtf8('1234567890123456'); // 16 chars

  static final _encrypter = Encrypter(
    AES(
      _key,
      mode: AESMode.cbc,
      padding: 'PKCS7',
    ),
  );

  static String encryptText(String text) {
    final encrypted = _encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  static String decryptText(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}


// class CryptoHelper {
//   // ⚠️ Debe ser 32 chars (AES-256)
//   static final _key = Key.fromUtf8('MI_CLAVE_SUPER_SECRETA_32_CHARS!');
//   static final _iv = IV.fromLength(16);

//   static String encryptText(String text) {
//     final encrypter = Encrypter(AES(_key));
//     return encrypter.encrypt(text, iv: _iv).base64;
//   }

//   static String decryptText(String encrypted) {
//     final encrypter = Encrypter(AES(_key));
//     return encrypter.decrypt64(encrypted, iv: _iv);
//   }
// }


 