import 'package:flutter/material.dart';
import '../models/selected_event.dart';
import '../utils/cart_item.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventSummaryPage extends StatelessWidget {
  final List<CartItem> cartItems;
  final String eventTitle;
  final String eventDate;
  final String eventLocation;
  final String eventImage;

  const EventSummaryPage({
    super.key,
    required this.cartItems,
    required this.eventTitle,
    required this.eventDate,
    required this.eventLocation,
    required this.eventImage,
  });

  void _showQRDialog(BuildContext context) {
    final qrData =
        'Evento: $eventTitle\nFecha: $eventDate\nUbicación: $eventLocation';

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Código QR del Evento'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                const SizedBox(height: 12),
                const Text('Escanea este código para validar tu acceso.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fallbackEvent = selectedEvent;

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen del Evento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                eventImage.isNotEmpty
                    ? eventImage
                    : fallbackEvent?.image ?? 'assets/images/default.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              eventTitle.isNotEmpty
                  ? eventTitle
                  : fallbackEvent?.title ?? 'Sin título',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha: ${eventDate.isNotEmpty ? eventDate : fallbackEvent?.date ?? ''}',
            ),
            Text(
              'Ubicación: ${eventLocation.isNotEmpty ? eventLocation : fallbackEvent?.location ?? ''}',
            ),
            const Divider(height: 32),
            const Text(
              'Boletos Seleccionados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            if (cartItems.isEmpty)
              const Text('No hay boletos en el carrito.')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    leading: const Icon(Icons.confirmation_number),
                    title: Text('${item.title} × ${item.quantity}'),
                    trailing: Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showQRDialog(context),
                icon: const Icon(Icons.qr_code),
                label: const Text('Mostrar QR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
