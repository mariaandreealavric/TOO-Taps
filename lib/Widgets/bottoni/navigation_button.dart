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

  const NavigationButton({
    super.key,
    required this.icon,
    required this.index,
    required this.routeName,
    required this.isSelected,
    required this.onTap,
    required this.touchController,
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
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              widget.isSelected ? Colors.blue : Colors.white, // Colore del cerchio
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'assets/dock_circle.png', // Percorso dell'immagine del cerchio
              width: 60, // Dimensioni del cerchio
              height: 60,
            ),
          ),
          Icon(
            widget.icon,
            size: 36.0,
            color: widget.isSelected ? Colors.white : Colors.black, // Cambia colore icona
          ),
        ],
      ),
    );
  }
}
