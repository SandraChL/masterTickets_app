import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login.dart';
import 'widgets/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MasterTickets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', // splash primero
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => LoginScreen(),
        // '/register': (context) => const RegisterScreen(),
       // '/form_booking': (context) => const FormBookingPage(),
      },
    );
  }
}
