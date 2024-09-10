import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/Contatori/touch_counter.dart';

class NavigationButton extends StatefulWidget {
  final IconData icon;
  final int index;
  final String routeName;
  final bool isSelected;
  final Function onTap;
  final TouchController touchController;
  final Color circleColor; // Aggiungi un parametro per il colore del cerchio

  const NavigationButton({
    super.key,
    required this.icon,
    required this.index,
    required this.routeName,
    required this.isSelected,
    required this.onTap,
    required this.touchController,
    required this.circleColor, // Colore del cerchio
  });

  @override
  _NavigationButtonState createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.index);
        widget.touchController.incrementTouches();
        Get.toNamed(widget.routeName);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: widget.circleColor, // Colore del cerchio
              shape: BoxShape.circle,
            ),
          ),
          Icon(
            widget.icon,
            size: 36.0,
            color: widget.isSelected ? Colors.black26 : Colors.black, // Cambia colore icona
          ),
        ],
      ),
    );
  }
}
