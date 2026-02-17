import 'package:flutter/material.dart';
import 'package:master_tickets/screens/home_screen.dart';
import 'package:master_tickets/screens/qrscaner.dart';
import 'models/cart.dart';
import 'screens/checkout_screen.dart';
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
        '/home': (context) => HomeScreen(),
        '/scan': (context) => QrScannerPage(),       
        '/checkout':
            (context) => CheckoutPage(
              cartItems: cart,
              eventTitle: '',
              eventDate: '',
              eventLocation: '',
              eventImage: '',
            ),

        // '/register': (context) => const RegisterScreen(),
        // '/form_booking': (context) => const FormBookingPage(),
      },
    );
  }
}
