import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:master_tickets/screens/orden_summary.dart';

import '../utils/cart_item.dart';
import '../utils/colors.dart';
import '../widgets/footer.dart';
 

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

  double get total =>
      widget.cartItems.fold(0, (sum, i) => sum + i.price * i.quantity);

  Future<void> makePayment() async {
    setState(() => _isLoading = true);

    try {
         final response = await http.post(
        Uri.parse('https://test.tukmein.com/api/create-payment-intent'),
        body: {
          'amount': '36300', // El monto en centavos (363.00)
          'currency': 'usd',
        },
      );

      final data = jsonDecode(response.body);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: data['clientSecret'],
          merchantDisplayName: 'TravelSpot',
          allowsDelayedPaymentMethods: false,
          billingDetailsCollectionConfiguration:
              const BillingDetailsCollectionConfiguration(
            email: CollectionMode.never,
            phone: CollectionMode.never,
            address: AddressCollectionMode.never,
          ),
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

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

    } catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.error.localizedMessage ?? 'Pago cancelado'),
          ),
        );
      } else {

          print('StripeException');
                          print( 'Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tu pedido',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ...widget.cartItems.map(
                (item) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.title} × ${item.quantity}'),
                    Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                  ],
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.aRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isLoading ? null : makePayment,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Realizar el pedido',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              const CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
