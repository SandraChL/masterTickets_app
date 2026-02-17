import 'package:encrypt/encrypt.dart' as encrypt;
 
 

String encryptQueryParams(String title, String date, String location) {
  final plainText = 'titulo=$title&fecha=$date&ubicacion=$location';

  // Clave de 32 caracteres (AES-256)
  final key = encrypt.Key.fromUtf8('12345678901234567890123456789012'); 
  final iv = encrypt.IV.fromLength(16); // Vector de inicialización

  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypter.encrypt(plainText, iv: iv);

  return encrypted.base64;
}



 