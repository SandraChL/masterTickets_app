import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:master_tickets/services/events_service.dart';
import 'package:master_tickets/utils/encrypta.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;


class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage>
    with SingleTickerProviderStateMixin {
  bool _scanned = false;
  String? encryptedValue;
  String? idCompra;

  late AnimationController _lineController;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();

    // Animación de barrido
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _lineAnimation =
        Tween<double>(begin: 0, end: 300).animate(_lineController);
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

Future<void> _handleScan(String rawValue) async {
  if (_scanned) return;
  _scanned = true;

  final original = '12345';
final encrypted = CryptoHelper.encryptText(original);
final decrypted = CryptoHelper.decryptText(encrypted);

print('ORIGINAL: $original');
print('ENCRYPTED: $encrypted');
print('DECRYPTED: $decrypted');



  print('📦 RAW QR: "$rawValue"');

  try {
    final cleanValue = rawValue.trim();

    // 🔥 SOLO UNA VEZ
    final decrypted = CryptoHelper.decryptText(cleanValue);

    print('📦 DECRYPTED QR: "$decrypted"');

    setState(() {
      encryptedValue = rawValue;
      idCompra = decrypted;
    });

  } catch (e) {
    _scanned = false;
    print('❌ ERROR DECRYPT');
    print(e);
  }
}


  Future<void> _activarCompra() async {
  if (idCompra == null) return;

  final token = await EventsService.getBranchId();

  try {
    final response = await http.get(
     Uri.parse('https://back.workingdevsolutions.com/happyPath/ScanApp?idTicket= $idCompra'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final Map<String, dynamic> json = jsonDecode(response.body);

    final bool success = json['success'] == true;
    final String message = json['message'] ?? 'Respuesta desconocida';

    if (success) {
      // ✅ Ticket válido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ $message'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // ❌ Ya validado / rechazado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ $message'),
          backgroundColor: Colors.red,
        ),
      );
    }

  } catch (e) {
    // ❌ Error real (red, parsing, token, etc)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❌ Error al validar el ticket'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(
                  onDetect: (capture) {
                    final barcode = capture.barcodes.first;
                    if (barcode.rawValue != null) {
                      _handleScan(barcode.rawValue!);
                    }
                  },
                ),

                // Marco del scanner
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                // 🔥 Línea verde animada
                AnimatedBuilder(
                  animation: _lineAnimation,
                  builder: (_, __) {
                    return Positioned(
                      top: _lineAnimation.value,
                      child: Container(
                        width: 260,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.8),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          if (idCompra != null) ...[
            const SizedBox(height: 16),
            Text(
//              '🎫 ID desencriptado:\n$idCompra',
               '🎫 Boleto Valido',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _activarCompra,
              child: const Text('Activar acceso'),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}