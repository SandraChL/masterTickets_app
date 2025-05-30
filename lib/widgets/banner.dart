import 'dart:async';
import 'package:flutter/material.dart';

class AutoBanner extends StatefulWidget {
  const AutoBanner({super.key});

  @override
  State<AutoBanner> createState() => _AutoBannerState();
}

class _AutoBannerState extends State<AutoBanner> {
  int _currentIndex = 0;
  final List<String> _images = [
    'assets/images/Speeding.gif',
    'assets/images/Driving.gif',
    'assets/images/car.gif',
  ];

  @override
  void initState() {
    super.initState();
    // Cambia de GIF cada 4 segundos
    Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _images.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            child: Image.asset(_images[_currentIndex], fit: BoxFit.cover),
          ),
          ClipRRect(
            child: Container(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // Texto + imagen arriba
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                // Imagen centrada arriba
                Image.asset(
                  'assets/images/FastFurious.png',
                  height: 180,
                  width: 500,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 10),

                // Texto del evento
                Text(
                  '¡EL EVENTO DEL AÑO!',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.yellow.shade700,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'ACTORES DE LA SAGA',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'YOUTUBERS',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'ARRANCONES/DRIFT',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'PREMIOS A LOS MEJORES AUTOS',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '¡Y MUCHO MÁS!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
