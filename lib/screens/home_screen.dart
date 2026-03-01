import 'package:flutter/material.dart';
import 'package:master_tickets/screens/login.dart';
import 'package:master_tickets/utils/session_manager.dart';
import 'package:master_tickets/widgets/admin_events_widget.dart';
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
  String? userName;
  bool showAdminPanel = false; // 👈 NUEVO

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await SessionManager.getUserName();
    setState(() {
      userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
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

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          // ❌ NO LOGUEADO
                          if (!isLogged) {
                            return Column(
                              children: [
                                const Text(
                                  'Inicia sesión para ver los eventos',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
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
                            );
                          }

                          // 🛂 ADMIN
                          if (userName == 'Administrador Admin') {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.qr_code_scanner),
                                    title: const Text('Estadisticas de los Eventos'),
                                    trailing: Icon(
                                      showAdminPanel
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        showAdminPanel = !showAdminPanel;
                                      });
                                    },
                                  ),
                                ),

                                if (showAdminPanel)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: AdminEventsWidget(),
                                  ),
                              ],
                            );
                          }

                          // 👤 USUARIO NORMAL
                          return const FeaturedEventsCarousel();
                        },
                      ),
                    ],
                  ),
                ),

                // 👇 footer normal, SIN Spacer
                const SizedBox(height: 40),
                const CustomFooter(),
              ],
            ),
          );
        },
      ),
    );
  }
}
