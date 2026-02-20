import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _idZonaKey = 'id_zona';
  static const String _idTicketKey = 'id_ticket';
  static const String _idEventoKey = 'id_evento';
  static const String _idTicketsKey = 'id_tickets';
  static const String _idTransactionKey = 'id_transaction';

  // ================== LOGIN ==================
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // ================== IDS ==================
  static Future<void> setZonaAndTicket({
    required int idZona,
    required int idTicket,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_idZonaKey, idZona);
    await prefs.setInt(_idTicketKey, idTicket);
  }

  static Future<int?> getIdZona() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_idZonaKey);
  }

  static Future<int?> getIdTicket() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_idTicketKey);
  }

  static Future<void> setIdEvento(int idEvento) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_idEventoKey, idEvento);
  }

  static Future<int?> getIdEvento() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_idEventoKey);
  }

  // ================== LISTA DE TICKETS ==================
  static Future<void> setIdTickets(List<int> idsTickets) async {
    final prefs = await SharedPreferences.getInstance();
    final idsAsString = idsTickets.map((e) => e.toString()).toList();
    await prefs.setStringList(_idTicketsKey, idsAsString);
  }

  static Future<List<int>> getIdTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final idsAsString = prefs.getStringList(_idTicketsKey) ?? [];
    return idsAsString.map(int.parse).toList();
  }

  // ================== TRANSACCIÓN ==================
  static Future<void> setIdTransaction(int idTransaction) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_idTransactionKey, idTransaction);
  }

  static Future<int?> getIdTransaction() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_idTransactionKey);
  }

  // ================== LIMPIAR SESIÓN (SIN BORRAR LOGIN) ==================
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    // Guardar estado de login
    final isLoggedIn = prefs.getBool(_isLoggedInKey);

    // Limpiar todo
    await prefs.clear();

    // Restaurar login
    if (isLoggedIn != null) {
      await prefs.setBool(_isLoggedInKey, isLoggedIn);
    }
  }
}
