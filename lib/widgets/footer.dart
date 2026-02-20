import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CustomFooter extends StatefulWidget {
  const CustomFooter({super.key});

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter> {
  String _versionText = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _versionText = '${info.version}+${info.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

          const Spacer(),

          // Texto en dos líneas para evitar overflow
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '© Master Tickets',
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                _versionText,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
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
