import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../utils/cart_item.dart';
import '../utils/colors.dart';
import '../widgets/footer.dart';
import '../utils/session_manager.dart';
import '../services/events_service.dart';
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

  // 🔥 FUNCIÓN PARA COMPLETAR TICKETS
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

  Future<void> payWithStripe() async {
    setState(() => _isLoading = true);

    try {
      // 1️⃣ Crear PaymentIntent
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

      // 2️⃣ Confirmar pago con Stripe
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              email: _emailController.text,
              name: '${_nameController.text} ${_lastNameController.text}',
            ),
          ),
        ),
      );

      // 3️⃣ OBTENER DATOS GUARDADOS
      final idsTickets = await SessionManager.getIdTickets();
      final idTransaction = await SessionManager.getIdTransaction();

      if (idsTickets.isEmpty || idTransaction == null) {
        throw Exception('No hay tickets o transacción válida');
      }

      // 4️⃣ MARCAR TICKETS COMO PAGADOS
      await enviarTicketsPagados(
        idsTickets: idsTickets,
        idTransaction: idTransaction,
      );

      // 5️⃣ LIMPIAR SESIÓN
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Detalles de facturación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre *',
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
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Datos de la tarjeta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CardField(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.aRed,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _isLoading ? null : payWithStripe,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Pagar ahora',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 30),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
