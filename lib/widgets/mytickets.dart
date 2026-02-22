import 'package:flutter/material.dart';
import 'package:master_tickets/models/miseventoscomprados.dart' as purchased;

class MyTicketsCard extends StatelessWidget {
  final purchased.Ticket ticket;
  final VoidCallback onQrPressed;

  const MyTicketsCard({
    super.key,
    required this.ticket,
    required this.onQrPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isScanned = ticket.scanapp;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          /// 🖼 Imagen
          if (ticket.imagen.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                ticket.imagen,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.confirmation_number, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.nameZona.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Boleto #${ticket.idTicket}'),
                      if (ticket.caracteristics.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            ticket.caracteristics,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(color: Colors.grey.shade400, height: 1),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isScanned ? 'Escaneado' : 'Válido',
                  style: TextStyle(
                    color: isScanned ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: isScanned ? null : onQrPressed,
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Ver QR'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}