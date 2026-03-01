import 'package:flutter/material.dart';
import 'package:master_tickets/screens/qrscaner.dart';
import 'package:master_tickets/utils/session_manager.dart';
import '../screens/event_List.dart';
import '../screens/login.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool showPersonalData = false;
  bool showEventCategories = false;
  String? userName;

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset("assets/images/WallUser.jpeg", fit: BoxFit.cover),
                Container(color: Colors.black.withOpacity(0.4)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      userName ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

       /// 👤 SOLO USUARIOS NO ADMIN
if (userName != 'Administrador Admin')
  ListTile(
    leading: const Icon(Icons.backpack_outlined),
    title: const Text('Tus Eventos'),
    onTap: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SelectedEventPage()),
      );
    },
  ),

/// 🛡️ SOLO ADMIN
if (userName == 'Administrador Admin')
  ListTile(
    leading: const Icon(Icons.qr_code_scanner),
    title: const Text('Scanear Tickets'),
    onTap: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QrScannerPage()),
      );
    },
  ),
          /// 🚪 TODOS
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Finalizar la sesión'),
            onTap: () async {
              await SessionManager.setLoggedIn(false);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

//personal data
class PersonalDataBottomSheet extends StatelessWidget {
  const PersonalDataBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Personal Data",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),

            _buildField("Name"),
            _buildField("User Name"),
            _buildField("Email", hint: "Select"),
            _buildField("Recovery Email", hint: "Select"),
            _buildField("Phone Number"),
            _buildField("Date of Birth"),
            _buildField("Address", hint: "Select"),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, {String hint = ""}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextField(
            decoration: InputDecoration(
              hintText: hint.isNotEmpty ? hint : null,
              suffixIcon: const Icon(Icons.copy),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
