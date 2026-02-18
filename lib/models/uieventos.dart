/* ============================
   UI MODEL
============================ */


class TicketModel {
  final String title;
  final double price;
  final String image;
  final int totaltickets;
  final int?  idticket;
  final bool isDiscount;
  final String description;

  TicketModel({
    required this.title,
    required this.price,
    required this.image,
    required this.totaltickets,
    this.idticket,
    required this.description,
    this.isDiscount = false,
  });
}
