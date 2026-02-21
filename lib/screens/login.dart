import 'package:flutter/material.dart';
import 'package:master_tickets/services/events_service.dart';
import 'package:master_tickets/utils/session_manager.dart';
import 'home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MaterialApp(home: LoginScreen()));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();





  Future<void> _login(BuildContext context) async {
  final String username = _usernameController.text.trim();
  final String password = _passwordController.text.trim();


  final resulthash = await EventsService.loginRequest(      password: password,    );

  //debugPrint(' resulthash  : ${resulthash['hash']}');

  if (username.isEmpty || password.isEmpty) {
    _showError('Completa todos los campos');
    return;
  }

  final url = Uri.parse('https://auth.workingdevsolutions.com/auth/loginUsers'); // 👈 tu endpoint

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userid': username,
        'pwd': resulthash['hash'],
      }),
    );

    // 🔍 VER STATUS CODE
    //debugPrint('STATUS CODE: ${response.statusCode}');

    // 🔍 VER BODY RAW
    //debugPrint('RESPONSE BODY: ${response.body}');

    // 🔍 DECODIFICAR JSON
    //final data = jsonDecode(response.body);

    // 🔍 VER JSON PARSEADO
    //debugPrint('DATA PARSEADA: $data');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      // 👇 ajusta según la respuesta real de tu backend
      if (data['status'] == 200) {
        await SessionManager.setLoggedIn(true);

        await SessionManager.setUserName(data['username']);


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        _showError(data['message'] ?? 'Credenciales inválidas');
      }
    } else {
      _showError('Error del servidor (${response.statusCode})');
    }
  } catch (e) {
    _showError('Error de conexión');
  }
}


void _showError(String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}



  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              SizedBox.expand(
                child: Image.asset(
                  "assets/images/loginfondo.png",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 200),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.50),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          hint: "Username",
                          icon: Icons.person,
                          controller: _usernameController,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          hint: "Password",
                          icon: Icons.lock,
                          isPassword: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.50),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 2,
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                                _login(context);
                              },
                            // onPressed: () {
                            //   final username = _usernameController.text.trim();
                            //   final password = _passwordController.text.trim();

                            //   if (username == 'test' &&
                            //       password == '123456789') {
                            //     Navigator.pushReplacement(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => const HomeScreen(),
                            //       ),
                            //     );
                            //   } else {
                            //     showDialog(
                            //       context: context,
                            //       builder: (context) => AlertDialog(
                            //         title: const Text('Error'),
                            //         content: const Text(
                            //             'Usuario o contraseña incorrectos.'),
                            //         actions: [
                            //           TextButton(
                            //             onPressed: () =>
                            //                 Navigator.of(context).pop(),
                            //             child: const Text('OK'),
                            //           ),
                            //         ],
                            //       ),
                            //     );
                            //   }
                            // },
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildTextField({
  required String hint,
  required IconData icon,
  required TextEditingController controller,
  bool isPassword = false,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.60),
      borderRadius: BorderRadius.circular(30),
    ),
    child: TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),

        /// 👁️ OJITO FUNCIONAL
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,

        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
  );
}
}
