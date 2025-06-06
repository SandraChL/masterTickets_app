import 'package:flutter/material.dart';
import '../utils/cart_item.dart';
import '../utils/colors.dart';
import '../screens/home_screen.dart';

class OrderSummaryPage extends StatelessWidget {
  final List<CartItem> cartItems;
  final String eventTitle;
  final String eventDate;
  final String eventLocation;
  final String eventImage;

  const OrderSummaryPage({
    super.key,
    required this.cartItems,
    required this.eventTitle,
    required this.eventDate,
    required this.eventLocation,
    required this.eventImage,
  });

  @override
  Widget build(BuildContext context) {
    final total = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resumen del Pedido',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.aRed,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Gracias por tu compra',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            /// Imagen del evento
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                eventImage,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            /// Info del evento
            Text(
              eventTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(eventDate),
            Text(eventLocation),
            const SizedBox(height: 20),

            /// Resumen de boletos
            const Text(
              'Resumen de tus boletos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text('${item.title} × ${item.quantity}'),
                    trailing: Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total pagado:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Botón Finalizar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.aRed,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false, // Elimina todas las páginas anteriores
                  );
                },
                child: const Text(
                  'Finalizar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
