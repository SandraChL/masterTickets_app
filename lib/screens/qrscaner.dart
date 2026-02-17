import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool _scanned = false;
  String? rawScannedUrl;
  String? idCompra;

  Future<void> _handleScan(String rawValue) async {
    print('📦 Código escaneado: $rawValue');

    if (_scanned) return;
    _scanned = true;

    try {
      final uri = Uri.parse(rawValue);
      final idventa = uri.queryParameters['idventa'];

      if (idventa == null) {
        throw Exception('La URL no contiene el parámetro "idventa".');
      }

      setState(() {
        idCompra = idventa;
        rawScannedUrl = rawValue;
      });

      // Si necesitas validar con una API externa antes de permitir activar:
      // final response = await http.post(
      //   Uri.parse('https://tuapi.com/validar'),
      //   body: {'idventa': idventa},
      // );
      // if (response.statusCode != 200) {
      //   throw Exception('No se pudo validar la venta');
      // }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    }
  }

  Future<void> _activarCompra() async {
    if (idCompra == null) return;

    final response = await http.post(
      Uri.parse('https://tuapi.com/activar'),
      body: {'idcompra': idCompra},
    );

    final msg = response.statusCode == 200
        ? '✅ Compra activada correctamente'
        : '❌ Error al activar la compra';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                if (barcode.rawValue != null) {
                  _handleScan(barcode.rawValue!);
                }
              },
            ),
          ),
          if (rawScannedUrl != null) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '🔍 URL escaneada:\n$rawScannedUrl',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
          if (idCompra != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ElevatedButton(
                onPressed: _activarCompra,
                child: const Text('Activar'),
              ),
            ),
        ],
      ),
    );
  }
}
