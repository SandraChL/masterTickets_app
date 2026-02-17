import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:master_tickets/models/eventos_modelo.dart';
import 'package:master_tickets/models/tickets.dart';
 

class EventsService {
  static Future<String> _getBranchId() async {
    final response = await http.post(
      Uri.parse('https://auth.workingdevsolutions.com/auth/loginUsers'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "userid": "ADADMIN9787",
        "pwd": "U2FsdGVkX1/6cL/GKDpnFRiHEUgImoImHxRYx4Ta8Eg=",
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error obteniendo branch');
    }

    final decoded = jsonDecode(response.body);
        //print("  $decoded");

    return decoded['TK'];
  }


  static Future<List<FeaturedEvent>> fetchFeaturedEvents() async {

     final token = await _getBranchId(); // 👈 primero

    final response = await http.post(
      Uri.parse('https://back.workingdevsolutions.com/happyPath/rdAllEvents?token=$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "branch": "home",
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al obtener eventos');
    }
 
    final decoded = jsonDecode(response.body);

    
print(decoded);
    final List data = decoded['data'];

    return data.map((e) => FeaturedEvent.fromJson(e)).toList();
  }


static Future<TicketResponse> fetchFeaturedTickets({
  required int idStage,
  required int idEvento,
  required int maxTickets,
}) async {

print('ids recibidos para buscar ');
 print('idStage');
  print(idStage);
   print('idEvento');
  print(idEvento);

     final token = await _getBranchId(); // 👈 primero

    final response = await http.post(
      Uri.parse('https://back.workingdevsolutions.com/happyPath/TicketforZone?token=$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "idstage":  idStage,
         "idevento": idEvento ,
          "maxtickets": 100,
      }),
    );


  print('-----------');
 // print(response.body);
  //print('RAW RESPONSE: ${response.body}');
    final decoded = jsonDecode(response.body);
    final ticketResponse = TicketResponse.fromJson(decoded);

    if (response.statusCode != 201) {
      throw Exception('Error al obtener eventos');
    }

    

    return ticketResponse;
  }
}
