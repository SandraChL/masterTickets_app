// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../screens/ticket_detail.dart';
import '../utils/colors.dart';

class TicketCard extends StatefulWidget {
  final String title;
  final double price;
  final String image;
  final bool isDiscount;
  final String description;
  final bool showDetails;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.showDetails,
    required this.onTap,
    this.isDiscount = false,
  });

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard>
    with SingleTickerProviderStateMixin {
 // bool showDetails = false;
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(covariant TicketCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showDetails && !_controller.isCompleted) {
      _controller.forward();
    } else if (!widget.showDetails && !_controller.isDismissed) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.asset(
                    widget.image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.3),
                  ),
                  if (widget.isDiscount)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.aRed,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'DESCUENTO',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(blurRadius: 4, color: Colors.black),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${widget.price} MXN',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(blurRadius: 4, color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ✅ Barrido lateral con forma ondeada y botón fijo
        if (widget.showDetails)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return ClipPath(
                    clipper: WaveClipper(progress: _animation.value),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      child: Container(
                        color: AppColors.aRed,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                15,
                                20,
                                80,
                              ),
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Text(
                                  widget.description,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 16,
                              bottom: 16,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black.withOpacity(
                                    0.2,
                                  ),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => TicketDetailPage(
                                            title: widget.title,
                                            price: widget.price,
                                            description: widget.description,
                                            image: widget.image, date: '',
                                          ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Continuar',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// 🎯 Custom clipper para efecto de bandera ondeada
class WaveClipper extends CustomClipper<Path> {
  final double progress;

  WaveClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final waveHeight = 20.0;
    final waveLength = size.height / 5;
    final path = Path();

    final revealWidth = size.width * progress;

    path.lineTo(revealWidth, 0);

    for (double y = 0; y <= size.height; y += waveLength) {
      path.quadraticBezierTo(
        revealWidth + waveHeight,
        y + waveLength / 4,
        revealWidth,
        y + waveLength / 2,
      );
      path.quadraticBezierTo(
        revealWidth - waveHeight,
        y + 3 * waveLength / 4,
        revealWidth,
        y + waveLength,
      );
    }

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => oldClipper.progress != progress;
}
