import 'package:flutter/material.dart';
import 'package:master_tickets/models/tickets.dart';
import 'package:master_tickets/services/events_service.dart';
import 'package:master_tickets/utils/session_manager.dart';
import '../models/cart_notifier.dart';
import '../utils/cart_item.dart';
import '../utils/colors.dart';
import '../widgets/carrito.dart';
import '../widgets/drawer.dart';
import '../widgets/footer.dart';


class TicketDetailPage extends StatefulWidget {
  final String title;
  final double price;
  final String description;
  final String image;
  final int totaltickets;

  const TicketDetailPage({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.image, 
    required this.totaltickets, 
    required String date,
  });

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  late Future<TicketResponse> _ticketsFuture;
  int cantidad = 1;
  int cartItemCount = 0;
  int? idTicket;
  int? idZona;

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }


  Future<void> _loadSessionData() async {
  final ticket = await SessionManager.getIdTicket();
    final zona = await SessionManager.getIdZona();

      setState(() {
      idTicket = ticket;
      idZona = zona;
    });

    print('❌ id ticket seleccionado: $ticket');
    print('❌ zona seleccionada: $zona');
  }



  void aumentarCantidad() {
    setState(() {
      cantidad++;
    });
  }

  void disminuirCantidad() {
    if (cantidad > 1) {
      setState(() {
        cantidad--;
      });
    }
  }


Future<List<int>> obtenerIdsTickets({
  required Future<TicketResponse> ticketsFuture,
  required int? idZona,
  required int cantidad,
}) async {
  final response = await ticketsFuture;

  final zona = response.data.firstWhere(
    (z) => z.idZona == idZona,
    orElse: () => throw Exception('Zona no encontrada'),
  );

  if (zona.arrayTickets.length < cantidad) {
    throw Exception('No hay suficientes boletos disponibles');
  }

  return zona.arrayTickets
      .take(cantidad)
      .map((t) => t.idTicket)
      .toList();
}



Future<void> enviarTicketsApartados({
  required List<int> idsTickets,
  required int idTransaction,
}) async {
  for (final idTicket in idsTickets) {
    await EventsService.apartarTicket(
      idTicket: idTicket,
//      idTransaction: idTransaction,
    );

    print('Ticket apartado correctamente => $idTicket');
  }
}



Future<void> agregarAlCarrito() async {
  final idEvento = await SessionManager.getIdEvento();
  if (idEvento == null) return;

  _ticketsFuture = EventsService.fetchFeaturedTickets(
    idStage: 123,
    idEvento: idEvento,
    maxTickets: 100,
  );

  final idsTickets = await obtenerIdsTickets(
    ticketsFuture: _ticketsFuture,
    idZona: idZona,
    cantidad: cantidad,
  );

  print('IDs asignados: $idsTickets');


  await SessionManager.setIdTickets(idsTickets);

  await enviarTicketsApartados(
    idsTickets: idsTickets,
   idTransaction: 99,
  );


  cartNotifier.addItem(
    CartItem(
      title: widget.title,
      price: widget.price,
      quantity: cantidad,
      image: widget.image,
    //  ticketIds: idsTickets, // 👈 aquí
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Añadiste $cantidad boleto(s) al carrito')),
  );
}




Future<void> agregarAlCarrito2() async {
  final idEvento = await SessionManager.getIdEvento();

  if (idEvento == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo identificar el evento')),
    );
    return;
  }

  _ticketsFuture = EventsService.fetchFeaturedTickets(
    idStage: 123,
    idEvento: idEvento, // ✅ ahora es int
    maxTickets: 100,
  );

  print('agregarAlCarrito => cantidad: $cantidad');
  print('agregarAlCarrito => idZona: $idZona');
  print('agregarAlCarrito => idTicket: $idTicket');

  cartNotifier.addItem(
    CartItem(
      title: widget.title,
      price: widget.price,
      quantity: cantidad,
      image: widget.image,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Añadiste boletos al carrito')),
  );
}


  @override
  Widget build(BuildContext context) {
    double total = widget.price * cantidad;

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomHeader(title: 'Ticket'),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  widget.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  Row(
                    children: const [
                      Icon(Icons.push_pin, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No te lo pierdas, compra tus boletos anticipados y ahorra.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Text('${widget.totaltickets} disponibles', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: disminuirCantidad,
                            ),
                            Text('$cantidad'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: aumentarCantidad,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.aRed,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: agregarAlCarrito,
                          child: const Text(
                            'Añadir al carrito',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total: \$${total.toStringAsFixed(2)} MXN',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
