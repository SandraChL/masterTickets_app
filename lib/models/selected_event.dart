// lib/models/selected_event.dart

class SelectedEvent {
  final String title;
  final String date;
  final String location;
  final String image;
  

  SelectedEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.image,
  });
}

// Instancia global temporal (sin usar Provider aún)
SelectedEvent? selectedEvent;
