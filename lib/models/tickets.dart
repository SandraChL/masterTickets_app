class TicketResponse {
  final bool success;
  final bool flagTickets; // 
  final String result;
  final String message;
  final List<ZoneData> data;

  TicketResponse({
    required this.success,
    required this.flagTickets,
    required this.result,
    required this.message,
    required this.data,
  });

  factory TicketResponse.fromJson(Map<String, dynamic> json) {
    return TicketResponse(
      success: json['success'] ?? false,
      result: json['result'] ?? '',
      message: json['message'] ?? '',
        // ✅ si no viene → false
      flagTickets: json['flagTickets'] == true ||
          json['flagTickets']?.toString().toLowerCase() == 'true',
      data: json['data'] != null
          ? List<ZoneData>.from(
              json['data'].map((x) => ZoneData.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'result': result,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}


class ZoneData {
  final int idZona;
  final String nameZona;
  final num zoneCost;
  final int numPlaces;
  final bool ticketsAvailable;
  final String? description;
  final String? imagen;
  final List<Ticket> arrayTickets;

  ZoneData({
    required this.idZona,
    required this.nameZona,
    required this.zoneCost,
    required this.numPlaces,
    required this.ticketsAvailable,
    this.description,
    this.imagen,
    required this.arrayTickets,
  });

  factory ZoneData.fromJson(Map<String, dynamic> json) {
    return ZoneData(
      idZona: json['id_zona'],
      nameZona: json['name_zona'],
      zoneCost: json['zone_cost'],
      numPlaces: json['num_places'],
      ticketsAvailable: json['tickets_available'] ?? false,
      description: json['description'],
      imagen: json['imagen'],
      arrayTickets: json['arrayTickets'] != null
          ? List<Ticket>.from(
              json['arrayTickets'].map((x) => Ticket.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_zona': idZona,
      'name_zona': nameZona,
      'zone_cost': zoneCost,
      'num_places': numPlaces,
      'tickets_available': ticketsAvailable,
      'description': description,
      'imagen': imagen,
      'arrayTickets': arrayTickets.map((x) => x.toJson()).toList(),
    };
  }
}


class Ticket {
  final int idTicket;
  final int idStage;
  final int idEvent;
  final int idUbic;
  final int idZona;
  final String nameZona;
  final num price;
  final bool pulledApart;
  final bool bought;
  final bool scanapp;
  final int? idTransaction;
  final bool available;
  final DateTime createAt;
  final DateTime updateAt;
  final int? idcompany;
  final String? caracteristics;

  Ticket({
    required this.idTicket,
    required this.idStage,
    required this.idEvent,
    required this.idUbic,
    required this.idZona,
    required this.nameZona,
    required this.price,
    required this.pulledApart,
    required this.bought,
    required this.scanapp,
    this.idTransaction,
    required this.available,
    required this.createAt,
    required this.updateAt,
    this.idcompany,
    this.caracteristics,
  });

factory Ticket.fromJson(Map<String, dynamic> json) {
  return Ticket(
    idTicket: json['id_ticket'] ?? 0,
    idStage: json['id_stage'] ?? 0,
    idEvent: json['id_event'] ?? 0,
    idUbic: json['id_ubic'] ?? 0,
    idZona: json['id_zona'] ?? 0,
    nameZona: json['name_zona'] ?? '',
    price: json['price'] ?? 0,

    // 🔥 AQUÍ ESTABA EL ERROR
    pulledApart: json['pulled_apart'] ?? false,
    bought: json['bought'] ?? false,
    scanapp: json['scanapp'] ?? false,
    available: json['available'] ?? false,

    idTransaction: json['id_transaction'],

    createAt: json['create_at'] != null
        ? DateTime.parse(json['create_at'])
        : DateTime.now(),

    updateAt: json['update_at'] != null
        ? DateTime.parse(json['update_at'])
        : DateTime.now(),

    idcompany: json['idcompany'],
    caracteristics: json['caracteristics'],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id_ticket': idTicket,
      'id_stage': idStage,
      'id_event': idEvent,
      'id_ubic': idUbic,
      'id_zona': idZona,
      'name_zona': nameZona,
      'price': price,
      'pulled_apart': pulledApart,
      'bought': bought,
      'scanapp': scanapp,
      'id_transaction': idTransaction,
      'available': available,
      'create_at': createAt.toIso8601String(),
      'update_at': updateAt.toIso8601String(),
      'idcompany': idcompany,
      'caracteristics': caracteristics,
    };
  }
}
