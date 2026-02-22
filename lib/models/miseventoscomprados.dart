class Ticket {
  final int idTicket;
  final int idZona;
  final String nameZona;
  final String description;
  final String imagen; // imagen con default
  final String caracteristics;
  final String name;
  final String lastname;
  final String email;
  final int phone; // phone con default
  final String country;
  final bool scanapp;

  Ticket({
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

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      idTicket: json['id_ticket'] ?? 0,
      idZona: json['id_zona'] ?? 0,
      nameZona: json['name_zona'] ?? '',
      description: json['description'] ?? '',
      imagen: json['imagen'] ??
          'https://workingdevsolutions.com/images/MasterT/B3.jpeg',
      caracteristics: json['caracteristics'] ?? '',
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? 0,
      country: json['country'] ?? '',
      scanapp: json['scanapp'] ?? false,
    );
  }
}

class Event {
  final int idevent;
  final String name;
  final DateTime fecha;
  final String description;
  final List<Ticket> tickets;

  Event({
    required this.idevent,
    required this.name,
    required this.fecha,
    required this.description,
    required this.tickets,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      idevent: json['idevent'],
      name: json['e_name'],
      fecha: DateTime.parse(json['fecha']),
      description: json['description'],
      tickets: (json['data'] as List)
          .map((e) => Ticket.fromJson(e))
          .toList(),
    );
  }
}

class ApiResponse {
  final bool success;
  final String result;
  final String message;
  final List<Event> data;

  ApiResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'],
      result: json['result'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => Event.fromJson(e))
          .toList(),
    );
  }
}