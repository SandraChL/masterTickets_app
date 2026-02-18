import 'package:flutter/material.dart';
import 'package:master_tickets/models/tickets.dart';
import 'package:master_tickets/models/uieventos.dart';
import 'package:master_tickets/services/events_service.dart';

import '../models/selected_event.dart';
import '../widgets/carrito.dart';
import '../widgets/drawer.dart';
import '../widgets/footer.dart';
import '../widgets/ticket_card.dart';
 



List<TicketModel> mapZonesToTicketModels(TicketResponse response) {
  return response.data
      .where((zone) =>
          zone.arrayTickets.any(
            (t) => !t.bought && !t.pulledApart,
          ))
      .map((zone) {
        final availableTickets = zone.arrayTickets
            .where((t) => !t.bought && !t.pulledApart)
            .toList();

        final minPrice = availableTickets
            .map((t) => t.price)
            .reduce((a, b) => a < b ? a : b);

        return TicketModel(
          title: zone.nameZona.toUpperCase(),
          price: minPrice.toDouble(),
          image: 'assets/images/Category.png',
          totaltickets:zone.arrayTickets.length,
          description: zone.description ?? 'Acceso ${zone.nameZona}',
        );
      })
      .toList();
}



/* ============================
   ADAPTER API → UI
============================ */
List<TicketModel> mapTicketsFromResponse(TicketResponse response) {
  final List<TicketModel> tickets = [];

  for (final zone in response.data) {
    for (final ticket in zone.arrayTickets) {
      // 🔥 FILTRO CORRECTO
      if (ticket.bought || ticket.pulledApart) continue;

      tickets.add(
        TicketModel(
          title: zone.nameZona.toUpperCase(),
          price: ticket.price.toDouble(),
          image: 'assets/images/Category.png',
          totaltickets:zone.arrayTickets.length,
          description: zone.description ?? 'Acceso ${zone.nameZona}',
        ),
      );
    }
  }

  return tickets;
}


/* ============================
   PAGE
============================ */
class EventDetailPage extends StatefulWidget {
  final String title;
  final String date;
  final String location;
  final String image;
  final int idstage;
  final int idevento;

  const EventDetailPage({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.idstage,
    required this.idevento,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;
  int? expandedIndex;

  late Future<TicketResponse> _ticketsFuture;

  @override
  void initState() {
    super.initState();

      _ticketsFuture = EventsService.fetchFeaturedTickets(
      idStage: widget.idstage,
      idEvento: widget.idevento,
      maxTickets: 100,
    );

    selectedEvent = SelectedEvent(
      title: widget.title,
      date: widget.date,
      location: widget.location,
      image: widget.image,
    );

    _scrollController.addListener(() {
      final atBottom = _scrollController.offset >=
          _scrollController.position.maxScrollExtent;

      if (atBottom != _isAtBottom) {
        setState(() {
          _isAtBottom = atBottom;
        });
      }
    });
  }

  void _scrollToPosition() {
    _scrollController.animateTo(
      _isAtBottom ? 0 : _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomHeader(title: 'Eventos'),

      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToPosition,
        backgroundColor: Colors.white,
        child: Icon(
          _isAtBottom ? Icons.arrow_upward : Icons.arrow_downward,
          color: Colors.black,
        ),
      ),

      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.image,
              height: 200,
              fit: BoxFit.cover,
            ),

            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Boletos disponibles ',
                style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<TicketResponse>(
                future: _ticketsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                if (snapshot.hasError) {
                  debugPrint('❌ Error cargando boletos');
                  debugPrint(snapshot.error.toString());
                 // debugPrint(snapshot.stackTrace.toString());

                  return const Center(
                    child: Text('Ocurrió un error al cargar los boletos'),
                  );
                }

                final response = snapshot.data!;

                debugPrint('flagTickets: ${response.flagTickets}');
                debugPrint('zones: ${response.data.length}');
                debugPrint(
                  'total tickets raw: ${response.data.fold<int>(0, (sum, z) => sum + z.arrayTickets.length)}',
                );

                final tickets = response.flagTickets
                    ? mapTicketsFromResponse(response)
                    : mapZonesToTicketModels(response);

                debugPrint('tickets mapped: ${tickets.length}');

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: 20),
                        child: TicketCard(
                          title: ticket.title,
                          price: ticket.price,
                          image: ticket.image,
                          isDiscount: ticket.isDiscount,
                          description: ticket.description,
                          totaltickets:ticket.totaltickets,
                          showDetails: expandedIndex == index,
                          onTap: () {
                            setState(() {
                              expandedIndex =
                                  expandedIndex == index
                                      ? null
                                      : index;
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
