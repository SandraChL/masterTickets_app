import 'package:flutter/material.dart';
import '../utils/cart_item.dart';
import '../widgets/carrito.dart';
import '../widgets/drawer.dart';
import '../widgets/footer.dart';


class TicketDetailPage extends StatefulWidget {
  final String title;
  final double price;
  final String description;
  final String image;

  const TicketDetailPage({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
  });

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  int cantidad = 1;
  int cartItemCount = 0;

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

  void agregarAlCarrito() {
    cartNotifier.addItem(
      CartItem(
        title: widget.title,
        price: widget.price,
        quantity: cantidad,
        image: widget.image,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Añadiste $cantidad boleto(s) al carrito.')),
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
                  const Text('461 disponibles', style: TextStyle(fontSize: 14)),
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
                            backgroundColor: Colors.red,
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
