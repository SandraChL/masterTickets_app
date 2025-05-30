import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Iconos sociales
          Row(
            children: [
              _buildSocialIcon(FontAwesomeIcons.facebookF),
              const SizedBox(width: 12),
              _buildSocialIcon(FontAwesomeIcons.instagram),
              const SizedBox(width: 12),
              _buildSocialIcon(FontAwesomeIcons.tiktok),
            ],
          ),

          // Texto copyright
          const Text(
            '© SUPERGARAGEFEST - 2025',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: Center(
        child: FaIcon(
          icon,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
