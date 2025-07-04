import 'package:flutter/material.dart';
import '../models/selected_event.dart';
import '../widgets/carrito.dart';
import '../widgets/drawer.dart';
import '../widgets/footer.dart';
import '../widgets/ticket_card.dart';
import '../models/cart.dart';

class TicketModel {
  final String title;
  final double price;
  final String image;
  final bool isDiscount;
  final String description;

  TicketModel({
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    this.isDiscount = false,
  });
}

class EventDetailPage extends StatefulWidget {
  final String title;
  final String date;
  final String location;
  final String image;

  const EventDetailPage({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.image,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;
  int get cartItemCount => cart.fold(0, (sum, item) => sum + item.quantity);
  int? expandedIndex;

  final List<TicketModel> tickets = [
    TicketModel(
      title: 'NIÑOS GENERAL',
      price: 150,
      image: 'assets/images/Category.png',
      isDiscount: true,
      description: '''Entrada Niños menores a 10 años (0 a 4 años GRATIS)
Precio en línea: \$150 MXN (en taquilla: \$200 MXN)
Incluye:
• Acceso General al Evento
• Boleto para el Sorteo HotWheels
• En compañía de un adulto''',
    ),

    TicketModel(
      title: 'GRADAS',
      price: 200,
      image: 'assets/images/Category.png',
      description: '''
Precio en línea: \$200 MXN
Incluye:
• 1 Acceso a Gradas para Show en Pista
• Niños Gratis
• Cupo limitado''',
    ),

    TicketModel(
      title: 'GENERAL',
      price: 350,
      image: 'assets/images/Category.png',
      isDiscount: true,
      description: '''Precio en línea: \$350 MXN
Incluye:
• Entrada general al evento
• Acceso a exhibición de autos, stands, actividades y shows''',
    ),

    TicketModel(
      title: 'ACCESO RAPIDO',
      price: 500,
      image: 'assets/images/Category.png',
      description: '''Precio en línea: \$500 MXN

Incluye:
• Estacionamiento cerca del Evento
• Acceso General
• Boleto Sorteos
''',
    ),

    TicketModel(
      title: 'SUPERMEET CLUB',
      price: 1200,
      image: 'assets/images/Category.png',
      description:
          '''Inscripción de Club – Exhibición Supermeet, Costo por Auto, + 5 autos
(Registro por WhatsApp hasta el 01 de Junio)
Precio en línea: \$1200 MXN 

Incluye:
• Acceso Piloto
• Estacionamiento de Exhibición
• Gafete Personalizado Piloto
• Concurza por Premios
• Reconocimientos
• Boleto Sorteros
''',
    ),

    TicketModel(
      title: 'SUPERMEET',
      price: 1500,
      image: 'assets/images/Category.png',
      description: '''
Precio en línea: \$1500 MXN

Incluye:
• Acceso General al Evento
• Zona Preferencial Exhibición
• Gafete Personalizado
• Participa por Premios
• Boleto Sorteros
''',
    ),

    TicketModel(
      title: 'MEDIOS Y CREADORES',
      price: 1500,
      image: 'assets/images/Category.png',
      description: '''
Precio en línea: \$1500 

Incluye:
• Invitación a Rueda de Prensa
• Acceso General al Evento
•  Estacionamiento Preferencial
•  Gafete Personalizado
•  Acceso a Gradas
•  Acceso a Zonas Especiales con Gafete
''',
    ),

    TicketModel(
      title: 'CARSHOW VIP',
      price: 2500,
      image: 'assets/images/Category.png',
      description: '''DISPONIBLE HASTA EL 01 DE JUNIO
Precio en línea: \$2500 MXN

Incluye:
• Exhibición Principal bajo Techo
• Acceso Piloto y Copiloto
•  Gafete Personalizado
•  Concursa por Premio al Mejor Auto
•  Participa en Show de Pista F&F
•  Boleto para Sorteo
''',
    ),

    TicketModel(
      title: 'VIP PLATA',
      price: 2500,
      image: 'assets/images/Category.png',
      description: '''DISPONIBLE HASTA EL 01 DE JUNIO
Precio en línea: \$2500 MXN 

Incluye:
• Acceso General al Evento
• Boleto para el Sorteo HotWheels
• En compañía de un adulto''',
    ),

    TicketModel(
      title: 'VIP ORO',
      price: 3500,
      image: 'assets/images/Category.png',
      description: '''DISPONIBLE HASTA EL 01 DE JUNIO
Precio en línea: \$3500 MXN 

Incluye:
• Meet and Grat con Actores F&F y YouTuber’s
• Playera Oficial SGF Autografiada
• Gafete Personalizado
• Cómoda Zona VIP con Baños Privados
• Estacionamiento Cerca del Evento
• Acceso a Gradas
• Sorteos
''',
    ),

    TicketModel(
      title: 'SUPER VIP',
      price: 8500,
      image: 'assets/images/Category.png',
      description: '''DISPONIBLE HASTA EL 01 DE JUNIO
Precio en línea: \$8500 MXN 

Incluye:
• Todos los beneficierios acceso vip oro 
• Taxidrift con pilotos profecionales
• Copiloto en auto F&F durante show en pista 
• Sesión de fotos y aparición en Aftermovie
''',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Guarda los valores del evento actual
    selectedEvent = SelectedEvent(
      title: widget.title,
      date: widget.date,
      location: widget.location,
      image: widget.image,
    );

    _scrollController.addListener(() {
      final isAtBottomNow =
          _scrollController.offset >=
          _scrollController.position.maxScrollExtent;
      setState(() {
        _isAtBottom = isAtBottomNow;
      });
    });
  }

  void _scrollToPosition() {
    if (_isAtBottom) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomHeader(title: 'Eventos'),

      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToPosition,
        backgroundColor: Colors.white,
        elevation: 6, // Sombra
        shape: const CircleBorder(),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    widget.image,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.date,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          widget.location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Boletos disponibles',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: TicketCard(
                          title: ticket.title,
                          price: ticket.price,
                          image: ticket.image,
                          isDiscount: ticket.isDiscount,
                          description: ticket.description,
                          showDetails: expandedIndex == index,
                          onTap: () {
                            setState(() {
                              expandedIndex =
                                  expandedIndex == index ? null : index;
                            });
                          },
                        ),
                      );
                    },
                  ),
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
