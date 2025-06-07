// import 'package:flutter/material.dart';
// import '../models/selected_event.dart';

// class SelectedEventPage extends StatelessWidget {
//   const SelectedEventPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     if (selectedEvent == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text('Tus Eventos')),
//         body: const Center(child: Text('No has seleccionado ningún evento.')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Detalles del Evento')),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Card(
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize:
//                   MainAxisSize.min, // 👈 evita que se alargue innecesariamente
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.asset(
//                     selectedEvent!.image,
//                     height: 140, // 👈 más pequeña
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   selectedEvent!.title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(selectedEvent!.date, style: const TextStyle(fontSize: 13)),
//                 Text(
//                   selectedEvent!.location,
//                   style: const TextStyle(fontSize: 13),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/selected_event.dart';
import '../utils/cart_item.dart';
import 'detail_ticket.dart';

class SelectedEventPage extends StatelessWidget {
  const SelectedEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (selectedEvent == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tus Eventos')),
        body: const Center(child: Text('No has seleccionado ningún evento.')),
      );
    }

    // Simula una lista de boletos comprados (puedes reemplazarlo con los reales si los tienes)
    final List<CartItem> cartItems = [
      CartItem(title: 'General', quantity: 2, price: 150, image: ''),
      CartItem(title: 'VIP', quantity: 1, price: 300, image: ''),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Evento')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => EventSummaryPage(
                      cartItems: cartItems,
                      eventTitle: selectedEvent!.title,
                      eventDate: selectedEvent!.date,
                      eventLocation: selectedEvent!.location,
                      eventImage: selectedEvent!.image,
                    ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      selectedEvent!.image,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    selectedEvent!.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedEvent!.date,
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    selectedEvent!.location,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
