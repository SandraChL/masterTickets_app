class MyTicketsResponse {
  final bool success;
  final String result;
  final List<TicketData> data;

  MyTicketsResponse({
    required this.success,
    required this.result,
    required this.data,
  });

  factory MyTicketsResponse.fromJson(Map<String, dynamic> json) {
    return MyTicketsResponse(
      success: json['success'] ?? false,
      result: json['result'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => TicketData.fromJson(e))
          .toList(),
    );
  }
}


class TicketData {
  final int idTicket;
  final int idZona;
  final String nameZona;
  final String description;
  final String imagen;
  final dynamic caracteristics;
  final String name;
  final String lastname;
  final String email;
  final int phone;
  final String country;
  final bool scanapp;

  TicketData({
    required this.idTicket,
    required this.idZona,
    required this.nameZona,
    required this.description,
    required this.imagen,
    required this.caracteristics,
    required this.name,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.country,
    required this.scanapp,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      idTicket: json['id_ticket'] ?? 0,
      idZona: json['id_zona'] ?? 0,
      nameZona: json['name_zona'] ?? '',
      description: json['description'] ?? '',
      imagen: json['imagen'] ?? '',
      caracteristics: json['caracteristics'],
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? 0,
      country: json['country'] ?? '',
      scanapp: json['scanapp'] ?? false,
    );
  }
}