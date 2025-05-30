import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/ticket_card.dart';

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
•  Niños Gratis
•  Cupo limitado''',
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
• Boleto Sorteos''',
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
      description: '''Entrada Niños menores a 10 años (0 a 4 años GRATIS)
Precio en línea: \$150 MXN (en taquilla: \$200 MXN)

Incluye:
• Acceso General al Evento
• Boleto para el Sorteo HotWheels
• En compañía de un adulto''',
    ),
    TicketModel(
      title: 'MEDIOS Y CREADORES',
      price: 1500,
      image: 'assets/images/Category.png',
      description: '''Entrada Niños menores a 10 años (0 a 4 años GRATIS)
Precio en línea: \$150 MXN (en taquilla: \$200 MXN)

Incluye:
• Acceso General al Evento
• Boleto para el Sorteo HotWheels
• En compañía de un adulto''',
    ),
    TicketModel(
      title: 'CARSHOW VIP',
      price: 2500,
      image: 'assets/images/Category.png',
      description: '''Entrada Niños menores a 10 años (0 a 4 años GRATIS)
Precio en línea: \$150 MXN (en taquilla: \$200 MXN)

Incluye:
• Acceso General al Evento
• Boleto para el Sorteo HotWheels
• En compañía de un adulto''',
    ),
    TicketModel(
      title: 'VIP PLATA',
      price: 2500,
      image: 'assets/images/Category.png',
      description: '''Entrada Niños menores a 10 años (0 a 4 años GRATIS)
Precio en línea: \$150 MXN (en taquilla: \$200 MXN)

Incluye:
• Acceso General al Evento
• Boleto para el Sorteo HotWheels
• En compañía de un adulto''',
    ),
    TicketModel(
      title: 'VIP ORO',
      price: 3500,
      image: 'assets/images/Category.png',
      description: '''Entrada Niños menores a 10 años (0 a 4 años GRATIS)
Precio en línea: \$150 MXN (en taquilla: \$200 MXN)

Incluye:
• Acceso General al Evento
• Boleto para el Sorteo HotWheels
• En compañía de un adulto''',
    ),
    TicketModel(
      title: 'SUPER VIP',
      price: 8500,
      image: 'assets/images/Category.png',
      description: '''Entrada Niños menores a 10 años (0 a 4 años GRATIS)
Precio en línea: \$150 MXN (en taquilla: \$200 MXN)

Incluye:
• Acceso General al Evento
• Boleto para el Sorteo HotWheels
• En compañía de un adulto''',
    ),
  ];

  @override
  void initState() {
    super.initState();
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
      appBar: const CustomAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToPosition,
        backgroundColor: Colors.white,
        elevation: 6, // Sombra
        shape: const CircleBorder(),
        child: Icon(
          _isAtBottom ? Icons.arrow_upward : Icons.arrow_downward,
          color: Colors.black87,
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
                  top: 12,
                  left: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
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
                      return TicketCard(
                        title: ticket.title,
                        price: ticket.price,
                        image: ticket.image,
                        isDiscount: ticket.isDiscount,
                        description: ticket.description,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
