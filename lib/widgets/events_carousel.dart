import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../screens/categories_events.dart';

class FeaturedEventsCarousel extends StatefulWidget {
  const FeaturedEventsCarousel({super.key});

  @override
  State<FeaturedEventsCarousel> createState() => _FeaturedEventsCarouselState();
}

class _FeaturedEventsCarouselState extends State<FeaturedEventsCarousel> {
  final PageController _controller = PageController();

  final List<Map<String, String>> events = [
    {
      'title': 'Hot Wheels Legends Tour 2025 - CDMX',
      'date': '10/10/2024 | 12:00 PM',
      'location': 'Autódromo Hermanos Rodríguez - CDMX',
      'image': 'assets/images/B1.jpg',
    },
    {
      'title': 'Exhibición Muscle Cars & Clásicos',
      'date': '11/02/2024 | 10:00 AM',
      'location': 'Centro Expositor Puebla - PUE',
      'image': 'assets/images/B2.png',
    },
    {
      'title': 'Arrancones Nocturnos CDMX',
      'date': '09/28/2024 | 08:30 PM',
      'location': 'Centro Dinámico Pegaso - EDOMEX',
      'image': 'assets/images/WallUser.jpeg',
    },
    {
      'title': 'Expo Racing y Drift México',
      'date': '12/07/2024 | 01:00 PM',
      'location': 'Parque Fundidora - MTY',
      'image': 'assets/images/B1.jpg',
    },
    {
      'title': 'Encuentro Nacional de Autos VW',
      'date': '08/31/2024 | 09:00 AM',
      'location': 'Centro de Convenciones Oaxaca - OAX',
      'image': 'assets/images/B2.png',
    },
    {
      'title': 'Showroom Superautos 2025',
      'date': '11/17/2024 | 03:00 PM',
      'location': 'Explanada Poliforum León - GTO',
      'image': 'assets/images/WallUser.jpeg',
    },
    {
      'title': 'Festival Tuning & Custom México',
      'date': '10/26/2024 | 01:00 PM',
      'location': 'Foro Pegaso - EDOMEX',
      'image': 'assets/images/B1.jpg',
    },
    {
      'title': 'Auto Fest Norte 2025',
      'date': '09/14/2024 | 11:00 AM',
      'location': 'Parque Bicentenario - NL',
      'image': 'assets/images/B2.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Eventos Principales',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Podrás elegir los mejores eventos y vivir una gran experiencia',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 240,
            child: PageView.builder(
              controller: _controller,
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => EventDetailPage(
                              title: event['title']!,
                              date: event['date']!,
                              location: event['location']!,
                              image: event['image']!,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            event['image']!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event['date']!,
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          event['location']!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SmoothPageIndicator(
              controller: _controller,
              count: events.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
