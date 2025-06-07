import 'cart_item.dart';

class PurchasedEvent {
  final String title;
  final String date;
  final String location;
  final String image;
  final List<CartItem> tickets;

  PurchasedEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.tickets,
  });
}

List<PurchasedEvent> purchasedEvents = [];
