import 'package:flutter/material.dart';
import 'package:master_tickets/screens/login.dart';
import 'package:master_tickets/utils/session_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/banner.dart';
import '../widgets/drawer.dart';
import '../widgets/events_carousel.dart';
import '../widgets/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AutoBanner(),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          FutureBuilder<bool>(
                            future: SessionManager.isLoggedIn(),
                            builder: (context, snapshot) {
                              final isLogged = snapshot.data ?? false;

                              if (isLogged) {
                                return const FeaturedEventsCarousel();
                              }

                              // ❌ NO logueado
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Inicia sesión para ver los eventos',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text('Iniciar sesión'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // 👇 Empuja el footer al fondo
                    const Spacer(),

                    const CustomFooter(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
