import 'package:flutter/material.dart';
import 'detail_ticket.dart';  


class SelectedEventPage extends StatelessWidget {
  const SelectedEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    /// 🔹 Simulación de eventos comprados
    final events = [
      {
        'title': 'Concierto Rock Fest',
        'date': '20 Sep 2026',
        'location': 'Arena CDMX',
        'image':
            'https://workingdevsolutions.com/images/MasterT/B3.jpeg',
        'idventa': 'TXN_1001',
      },
      {
        'title': 'Festival Electrónico',
        'date': '05 Oct 2026',
        'location': 'Foro Sol',
        'image':'https://workingdevsolutions.com/images/MasterT/B3.jpeg',
        'idventa': 'TXN_1002',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tus eventos')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                /// 👉 SOLO PASAMOS idventa
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EventSummaryPage(),
                    settings: RouteSettings(
                      arguments: event['idventa'],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        event['image'] as String,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['title'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            event['date'] as String,
                            style: const TextStyle(fontSize: 13),
                          ),
                          Text(
                            event['location'] as String,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}