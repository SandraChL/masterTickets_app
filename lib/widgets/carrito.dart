import 'package:flutter/material.dart';
import '../screens/checkout_screen.dart';
import '../screens/login.dart';
import '../utils/colors.dart';
import '../utils/cart_item.dart';
import '../utils/event_info.dart';

/// NOTIFICADOR (ESTADO GLOBAL SIMPLE)
class CartNotifier extends ValueNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    final existingIndex = value.indexWhere((i) => i.title == item.title);
    if (existingIndex != -1) {
      value[existingIndex].quantity += item.quantity;
    } else {
      value = [...value, item];
    }
    notifyListeners();
  }

  void clear() {
    value = [];
    notifyListeners();
  }

  int get totalItems => value.fold(0, (sum, item) => sum + item.quantity);

  List<CartItem> get cartItems => value;
}

final cartNotifier = CartNotifier();

/// CABECERA CON ÍCONO REACTIVO
class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomHeader({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  void initState() {
    super.initState();
    cartNotifier.addListener(_onCartChanged);
  }

  void _onCartChanged() {
    setState(() {}); // Redibuja cuando cambia el carrito
  }

  @override
  void dispose() {
    cartNotifier.removeListener(_onCartChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItemCount = cartNotifier.totalItems;
    final canGoBack = Navigator.of(context).canPop();

    return AppBar(
  automaticallyImplyLeading: false,
  backgroundColor: AppColors.aRed,
  elevation: 0,
  title: Row(
    children: [
      Expanded(
        child: Row(
          children: [
            if (canGoBack)
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (_) => const LoginScreen()),
            //     );
            //   },
            //   child: Image.asset(
            //     'assets/images/LogoSGF.jpeg',
            //     height: 30,
            //     fit: BoxFit.contain,
            //   ),
            // ),
          ],
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.min, // 👈 clave para evitar que se expanda demasiado
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {
                    if (cartNotifier.cartItems.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutPage(
                            cartItems: cartNotifier.cartItems,
                            eventTitle: selectedEventTitle ?? '',
                            eventDate: selectedEventDate ?? '',
                            eventLocation: selectedEventLocation ?? '',
                            eventImage: selectedEventImage ?? '',
                          ),
                        ),
                      );
                    }
                  },
                ),
                if (cartItemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        '$cartItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ],
      ),
    ],
  ),
);


  }
}
