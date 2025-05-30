import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _positionAnimation = Tween<double>(
      begin: -300,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _rotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
    Timer(Duration(seconds: 4), () {
      Navigator.of(
        context,
      ).pushReplacementNamed('/home'); // asegúrate de tener esa ruta
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: AnimatedBuilder(
  //       animation: _controller,
  //       builder: (context, child) {
  //         return Opacity(
  //           opacity: _fadeAnimation.value,
  //           child: Transform.translate(
  //             offset: Offset(_positionAnimation.value, 50),
  //             child: Transform.rotate(
  //               angle: _rotationAnimation.value,
  //               child: Center(
  //                 child: Image.asset(
  //                   'assets/images/carro.png',
  //                   width: 280,
  //                   fit: BoxFit.contain,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // // 🌟 Imagen del logo arriba
                // SizedBox(
                //   width: 200,
                //   height: 80,
                //   child: Image.asset(
                //     'assets/images/LogoSGF.jpeg',
                //     fit: BoxFit.contain,
                //   ),
                // ),
                Transform.translate(
                  offset: Offset(_positionAnimation.value, 50),
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Image.asset(
                      'assets/images/carro.png',
                      width: 280,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
