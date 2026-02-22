class MyTransaccionResponse {
  final int idTransactions;

  MyTransaccionResponse({
    required this.idTransactions,
  });

  factory MyTransaccionResponse.fromJson(Map<String, dynamic> json) {
    return MyTransaccionResponse(
      idTransactions: json['id_transactions'],
    );
  }
}