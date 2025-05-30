// import 'package:flutter/material.dart';

// class TicketDetailPage extends StatelessWidget {
//   final String title;
//   final double price;
//   final String description;
//   final String image;

//   const TicketDetailPage({
//     super.key,
//     required this.title,
//     required this.price,
//     required this.description,
//     required this.image,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(
//                 16,
//               ),
//               child: Image.asset(
//                 image,
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),

//             const SizedBox(height: 20),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Text(description, style: const TextStyle(fontSize: 16)),

//             const SizedBox(height: 30),
//             const Divider(),

//             // Texto con pin
//             Row(
//               children: const [
//                 Icon(Icons.push_pin, color: Colors.red),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'No te lo pierdas, compra tus boletos anticipados y ahorra.',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                 ),
//               ],
//             ),

//             const Divider(height: 32),

//             const Text('461 disponibles', style: TextStyle(fontSize: 14)),
//             const SizedBox(height: 12),

//             // Selector y botón
//             Row(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.remove),
//                         onPressed: () {
//                           // lógica para restar cantidad
//                         },
//                       ),
//                       const Text('1'),
//                       IconButton(
//                         icon: const Icon(Icons.add),
//                         onPressed: () {
//                           // lógica para sumar cantidad
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     onPressed: () {
//                       // acción para añadir al carrito
//                     },
//                     child: const Text(
//                       'Añadir al carrito',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'checkout_screen.dart';

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
    setState(() {
      cartItemCount += cantidad;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Añadiste $cantidad boleto(s) al carrito.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.price * cantidad;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.aRed,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Color del icono de retroceso
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutPage(),
                    ),
                  );
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                widget.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(widget.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            const Divider(),

            // Texto con pin
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

            // Selector y botón
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
