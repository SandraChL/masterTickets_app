import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:http/http.dart' as http;

import '../utils/cart_item.dart';
import '../utils/colors.dart';
import '../utils/session_manager.dart';
import '../services/events_service.dart';
import '../widgets/footer.dart';
import 'orden_summary.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final String eventTitle;
  final String eventDate;
  final String eventLocation;
  final String eventImage;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.eventTitle,
    required this.eventDate,
    required this.eventLocation,
    required this.eventImage,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();

  double get total =>
      widget.cartItems.fold(0, (sum, i) => sum + i.price * i.quantity);

  // 🔥 COMPLETAR TICKETS
  Future<void> enviarTicketsPagados({
    required List<int> idsTickets,
    required int idTransaction,
  }) async {
    for (final idTicket in idsTickets) {
      await EventsService.completarTicket(
        idTicket: idTicket,
        idTransaction: idTransaction,
      );
      debugPrint('Ticket pagado => $idTicket');
    }
  }


    // 🔥 COMPLETAR TICKETS
  Future<void> getUdateTransaccion({
    required int idtransactions,
    required int numtickets,
    required int totalpricetickets,
      required int idzona,
  }) async {

  await EventsService.getUdateTransaccion(
        idtransactions: idtransactions,
         numtickets: numtickets,
        totalpricetickets: totalpricetickets,
        idzona: idzona,
      );
      debugPrint(' Transaccion  terminadaa  => $idtransactions');
  }

Future<void> payWithStripe() async {
  setState(() => _isLoading = true);

  try {
    // 1️⃣ Crear PaymentIntent en backend
    final response = await http.post(
      Uri.parse('https://test.tukmein.com/api/create-payment-intent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': (total * 100).toInt(),
        'currency': 'usd',
      }),
    );

    final data = jsonDecode(response.body);

    final clientSecret = data['clientSecret'];

    // 2️⃣ Inicializar Payment Sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Master Tickets',
        billingDetails: BillingDetails(
          email: _emailController.text,
          name: '${_nameController.text} ${_lastNameController.text}',
        ),
        style: ThemeMode.dark,
      ),
    );

    // 3️⃣ Mostrar Payment Sheet
    await Stripe.instance.presentPaymentSheet();

    // 4️⃣ Obtener sesión
    final idsTickets = await SessionManager.getIdTickets();
    final idTransaction = await SessionManager.getIdTransaction();
    
 
    final int idzona = await SessionManager.getIdZona() ?? 0;
     
final tickets = await SessionManager.getIdTickets();
final int totalTickets = tickets.length;



    if (idsTickets.isEmpty || idTransaction == null) {
      throw Exception('No hay tickets o transacción válida');
    }


    debugPrint('    --------- ');
    debugPrint('     ');
    debugPrint('_getBranchId  : ${idTransaction}');


    // 5️⃣ Marcar tickets como pagados
    await enviarTicketsPagados(
      idsTickets: idsTickets,
      idTransaction: idTransaction,
    );


        await getUdateTransaccion(
      idtransactions: idTransaction,
      numtickets: totalTickets,
      totalpricetickets: (total * 100).toInt(),
      idzona: idzona,
    );

    // 6️⃣ Limpiar sesión
    await SessionManager.clearSession();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Pago exitoso! 🎉'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSummaryPage(
          cartItems: widget.cartItems,
          eventTitle: widget.eventTitle,
          eventDate: widget.eventDate,
          eventLocation: widget.eventLocation,
          eventImage: widget.eventImage,
        ),
      ),
    );
  } on StripeException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.error.localizedMessage ?? 'Pago cancelado',
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finalizar compra',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.aRed,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          /// CONTENIDO
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Detalles de facturación',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre *',
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _lastNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Apellidos *',
                                    prefixIcon: Icon(Icons.person_outline),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Correo electrónico *',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

          

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.aRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _isLoading ? null : payWithStripe,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Pagar ahora',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          const CustomFooter(),
        ],
      ),
    );
  }
}