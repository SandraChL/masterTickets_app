class FeaturedEvent {
  final int id;
  final String title;
  final String date;
  final String location;
  final String image;
    final int idstage;
      final int idevento;

  FeaturedEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.idstage,
    required this.idevento,
  });

  factory FeaturedEvent.fromJson(Map<String, dynamic> json) {
    return FeaturedEvent(
      id: json['id_event'],
      title: json['name'] ?? '',
      date: json['DateSpecialformat'] ?? '',
      location: json['place'] ?? '',
      image: json['url_imagen'] ?? 'https://workingdevsolutions.com/images/MasterT/B3.jpeg',
      idstage: json['id_stage'] ?? 29,
      idevento: json['id_event'] ?? 123,
    );
  }
}
