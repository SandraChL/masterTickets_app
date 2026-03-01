import 'package:flutter/material.dart';
import 'package:master_tickets/models/miseventoscomprados.dart' as purchased;
import 'package:master_tickets/screens/QrScreen.dart';
import 'package:master_tickets/services/events_service.dart';
import 'package:master_tickets/utils/encrypta.dart';
import 'package:master_tickets/widgets/mytickets.dart';


class EventSummaryPage extends StatelessWidget {
  const EventSummaryPage({super.key});

  void _goToQrScreen(BuildContext context, String qrData) {
    final encryptedQr = CryptoHelper.encryptText(qrData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QrScreen(qrData: encryptedQr),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   final int idventa =
    ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis boletos')),
      body: FutureBuilder<List<purchased.Ticket>>(
        future: EventsService.getTickets(idTransaction: idventa),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los boletos'));
          }

          final tickets = snapshot.data ?? [];

          if (tickets.isEmpty) {
            return const Center(child: Text('No tienes boletos disponibles'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];

              return MyTicketsCard(
                ticket: ticket,
                onQrPressed: () {
                  final qrData = '${ticket.idTicket}';
                  _goToQrScreen(context, qrData);
                },
              );
            },
          );
        },
      ),
    );
  }
}