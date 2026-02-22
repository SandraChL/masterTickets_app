import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:master_tickets/models/eventos_modelo.dart';
import 'package:master_tickets/models/miseventoscomprados.dart' as purchased;
import 'package:master_tickets/models/mytickets.dart';
import 'package:master_tickets/models/tickets.dart';
import 'package:master_tickets/models/transaccion.dart';
import 'package:master_tickets/utils/session_manager.dart';

class EventsService {
  static Future<Map<String, dynamic>> loginRequest({
    required String password,
  }) async {
    final url = Uri.parse(
      'https://www.testunit00.co/testimonials/generatehash',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'value': password}),
    );

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    final data = jsonDecode(response.body);

    return {
      //'statusCode': response.statusCode,
      'hash': data['hash'],
    };
  }

  static Future<String> _getBranchId() async {
    final usersession = await SessionManager.getUserSession();

    final hashsession = await SessionManager.getHashSession();
    debugPrint('    --------- ');
    debugPrint('     ');
    debugPrint('_getBranchId  : ${usersession}');
    debugPrint('_getBranchId   : ${hashsession}');
    debugPrint('     ');
    debugPrint('   -----------  ');

    final response = await http.post(
      Uri.parse('https://auth.workingdevsolutions.com/auth/loginUsers'),
      headers: {'Content-Type': 'application/json'},
      // body: jsonEncode({
      //   "userid": "ADADMIN9787",
      //   "pwd": "U2FsdGVkX1/6cL/GKDpnFRiHEUgImoImHxRYx4Ta8Eg=",
      // }),
            body: jsonEncode({
        "userid": usersession,
        "pwd": hashsession,
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
      Uri.parse(
        'https://back.workingdevsolutions.com/happyPath/rdAllEvents?token=$token',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"branch": "home"}),
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
      Uri.parse(
        'https://back.workingdevsolutions.com/happyPath/TicketforZone?token=$token',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "idstage": idStage,
        "idevento": idEvento,
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

  static Future<void> apartarTicket({
    required int idTicket,
    //required int idTransaction,
  }) async {

       final idTransaction = await SessionManager.getIdTransaction();
    final token = await _getBranchId();
    final url = Uri.parse(
      'https://back.workingdevsolutions.com/happyPath/updateTicket?token=$token',
    );

    final body = {
      "id_ticket": idTicket,
      "id_transaction": idTransaction,
      "pulled_apart": true,
      "bought": false,
      "scanapp": false,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al apartar ticket $idTicket: ${response.body}');
    }
  }

  static Future<void> completarTicket({
    required int idTicket,
    required int idTransaction,
  }) async {
    final token = await _getBranchId();
    final url = Uri.parse(
      'https://back.workingdevsolutions.com/happyPath/updateTicket?token=$token',
    );

    final body = {
      "id_ticket": idTicket,
      "id_transaction": idTransaction,
      "pulled_apart": true,
      "bought": true,
      "scanapp": false,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al apartar ticket $idTicket: ${response.body}');
    }
  }

  static Future<MyTicketsResponse> getTicketsanterior({
    required String idTransaction,
  }) async {
    final token = await _getBranchId();
    final url = Uri.parse(
      'https://back.workingdevsolutions.com/happyPath/postFinalySale?token=$token',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_transaction': 999}),
    );

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    final Map<String, dynamic> data = jsonDecode(response.body);

    return MyTicketsResponse.fromJson(data);
  }


  static Future<List<purchased.Ticket>> getTickets({
  required int idTransaction,
}) async {
  final token = await _getBranchId();
  final url = Uri.parse('https://back.workingdevsolutions.com/crtTransactions/PurchasesPerUser');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> body = jsonDecode(response.body);

    // Tomamos el PRIMER evento (siempre hay uno)
    final List events = body['data'];
    final List ticketsJson = events.first['data'];

    return ticketsJson.map((e) => purchased.Ticket.fromJson(e)).toList();
  } else {
    throw Exception('Error al cargar tickets');
  }
}

  static Future<List<purchased.Event>> getTicketsByUser({
    required String idTransaction,
  }) async {
    final token = await _getBranchId();

          debugPrint('getTicketsByUser: ${token}');


    final url = Uri.parse(
      'https://back.workingdevsolutions.com/crtTransactions/PurchasesPerUser',
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

       debugPrint('getTicketsByUser: ${body}');

      final List eventsJson = body['data'];

      return eventsJson.map((e) => purchased.Event.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener eventos');
    }
  }

  static Future<MyTransaccionResponse> getTransaccion({
    required int id_stage,
    required int id_event,
  }) async {
    final token = await _getBranchId();
    final url = Uri.parse(
      'https://back.workingdevsolutions.com/crtTransactions/CreatBuy',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'id_stage': id_stage, 'id_event': id_event}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      debugPrint('RESPONSE BODY: ${response.body}');
      debugPrint('RESPONSE BODY: ${data['id_transactions']}');

      await SessionManager.setIdTransaction(data['id_transactions']);

      return MyTransaccionResponse.fromJson(data);
    } else {
      throw Exception('Error al obtener la transacción');
    }
  }



    static Future<MyTransaccionResponse> getUdateTransaccion({
    required int idtransactions,
    required int numtickets,
    required int totalpricetickets,
      required int idzona,
  }) async {
    final token = await _getBranchId();
    final url = Uri.parse(
      'https://back.workingdevsolutions.com/crtTransactions/UptBuy',
    );


     debugPrint('RESPONSE BODY: ${idtransactions}');
      debugPrint('RESPONSE BODY: ${numtickets}');
        debugPrint('RESPONSE BODY: ${totalpricetickets}');
      debugPrint('RESPONSE BODY: ${idzona}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id_transactions': idtransactions, 
        'id_typetransaction': 0,
        'id_zona': idzona,
        'number_of_tickets': numtickets,
        'total_ticket_price': totalpricetickets,
        'single_ticket_price': totalpricetickets,
        'finished': true,
        
        }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
 debugPrint(' ----------------getUdateTransaccion ------: ${data}');
      debugPrint('RESPONSE BODY: ${response.body}');
      debugPrint('RESPONSE BODY: ${data['id_transactions']}');

      await SessionManager.setIdTransaction(data['id_transactions']);

      return MyTransaccionResponse.fromJson(data);
    } else {
      throw Exception('Error al obtener la transacción');
    }
  }


}
