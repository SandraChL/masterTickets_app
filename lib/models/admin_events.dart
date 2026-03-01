class AdminEventsResponse {
  final bool success;
  final String result;
  final String message;
  final List<Company> data;

  AdminEventsResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.data,
  });

  factory AdminEventsResponse.fromJson(Map<String, dynamic> json) {
    return AdminEventsResponse(
      success: json['success'],
      result: json['result'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => Company.fromJson(e))
          .toList(),
    );
  }
}

class Company {
  final String company;
  final List<Stage> stages;

  Company({
    required this.company,
    required this.stages,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      company: json['company'],
      stages: (json['stages'] as List)
          .map((e) => Stage.fromJson(e))
          .toList(),
    );
  }
}

class Stage {
  final String id;
  final String name;
  final List<Event> events;

  Stage({
    required this.id,
    required this.name,
    required this.events,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'],
      name: json['name'],
      events: (json['events'] as List)
          .map((e) => Event.fromJson(e))
          .toList(),
    );
  }
}

class Event {
  final String id;
  final String name;
  final int idUbic;
  final List<Zone> zones;

  Event({
    required this.id,
    required this.name,
    required this.idUbic,
    required this.zones,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      idUbic: json['id_ubic'],
      zones: (json['zones'] as List)
          .map((e) => Zone.fromJson(e))
          .toList(),
    );
  }
}

class Zone {
  final String name;
  final int cost;
  final int qty;
  final int pulledApart;
  final int bought;
  final int scanapp;

  Zone({
    required this.name,
    required this.cost,
    required this.qty,
    required this.pulledApart,
    required this.bought,
    required this.scanapp,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      name: json['name'],
      cost: json['cost'],
      qty: json['qty'],
      pulledApart: json['pulled_apart'],
      bought: json['bought'],
      scanapp: json['scanapp'],
    );
  }
}