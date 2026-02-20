import 'package:flutter/material.dart';
import 'package:master_tickets/models/eventos_modelo.dart';
import 'package:master_tickets/services/events_service.dart';
import 'package:master_tickets/utils/session_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../screens/categories_events.dart';

class FeaturedEventsCarousel extends StatefulWidget {
  const FeaturedEventsCarousel({super.key});

  @override
  State<FeaturedEventsCarousel> createState() =>
      _FeaturedEventsCarouselState();
}

class _FeaturedEventsCarouselState extends State<FeaturedEventsCarousel> {
  final PageController _controller = PageController();
  late Future<List<FeaturedEvent>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = EventsService.fetchFeaturedEvents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FeaturedEvent>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No se encontraron eventos')),
          );
        }

        final events = snapshot.data!;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Eventos Principales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      onTap: () async {

                           print('idstage builder');
                          print( event.idstage);
                            print('idEvento builder');


                      

                          print(event.idevento);

                             
                             await SessionManager.setIdEvento(event.idevento);
                                      
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailPage(
                              title: event.title,
                              date: event.date,
                              location: event.location,
                              image: event.image,
                              idstage: event.idstage, 
                              idevento:event.idevento, 
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
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                      event.image,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return Image.network(
                                          'https://workingdevsolutions.com/images/MasterT/B3.jpeg',
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(event.date, style: const TextStyle(fontSize: 12)),
                            Text(
                              event.location,
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
      },
    );
  }
}
