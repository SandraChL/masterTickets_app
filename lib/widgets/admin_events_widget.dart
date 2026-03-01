import 'package:flutter/material.dart';
import 'package:master_tickets/services/events_service.dart';
import '../models/admin_events.dart';

class AdminEventsWidget extends StatelessWidget {
  const AdminEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdminEventsResponse>(
      future: EventsService.getAdminEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar eventos'));
        }

        final data = snapshot.data!;
        final company = data.data.first;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: company.stages.length,
          itemBuilder: (context, stageIndex) {
            final stage = company.stages[stageIndex];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    stage.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ...stage.events.map((event) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ExpansionTile(
                      title: Text(event.name),
                      children:
                          event.zones.isEmpty
                              ? [
                                const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text('Sin zonas'),
                                ),
                              ]
                              : event.zones.map((zone) {
                                return ListTile(
                                  title: Text(zone.name),
                                  subtitle: Text(
                                    'Costo: \$${zone.cost} | Total: ${zone.qty}',
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Vendidos: ${zone.bought}'),
                                      Text('Escaneados: ${zone.scanapp}'),
                                    ],
                                  ),
                                );
                              }).toList(),
                    ),
                  );
                }).toList(),
              ],
            );
          },
        );
      },
    );
  }
}
