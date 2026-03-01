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
    print(
      '🎟 Ticket ${ticket.idTicket} scanapp = ${ticket.scanapp} (${ticket.scanapp.runtimeType})',
    );

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
                     // Text('Boleto #${ticket.idTicket}'),
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
              children: [
                // 🟢 TEXTO DE ESTADO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isScanned ? 'Boleto Validado' : 'Boleto Activo',
                        style: TextStyle(
                          color: isScanned ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isScanned
                            ? 'Este boleto ya fue escaneado'
                            : 'Disponible para acceso',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // 🔲 BOTÓN QR
                ElevatedButton.icon(
                  onPressed: isScanned ? null : onQrPressed,
                  icon: const Icon(Icons.qr_code),
                  label: Text(isScanned ? 'Bloqueado' : 'Ver QR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isScanned ? Colors.grey : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
