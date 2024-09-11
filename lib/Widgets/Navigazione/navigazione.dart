import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/Contatori/touch_counter.dart';
import '../../models/profile_model.dart';

class Navigation extends StatefulWidget {
  final ProfileModel profile;

  const Navigation({super.key, required this.profile});

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  // Definisce le posizioni orizzontali relative per le icone
  final List<double> positions = [
    0.1,  // Posizione del primo pulsante
    0.45, // Posizione del secondo pulsante (centro)
    0.8,  // Posizione del terzo pulsante
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final touchController = Get.put(TouchController(widget.profile));
    double width = MediaQuery.of(context).size.width;

    // Calcolo della posizione orizzontale dinamica per il cerchio e la dockbar
    double dockBarWidth = width * 1.5; // Larghezza estesa della dockbar
    double circlePosition = width * positions[_selectedIndex]; // Posizione orizzontale del cerchio

    return Positioned(
      bottom: 0, // Posiziona la barra di navigazione in basso
      left: 0,
      right: 0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Dockbar e dock circle si muovono insieme
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300), // Durata dell'animazione
            left: circlePosition - (dockBarWidth / 4), // Centra la dockbar rispetto all'icona selezionata
            bottom: 0, // Posizione della dockbar
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/dockbar.png', // Immagine della dockbar
                  width: dockBarWidth, // Larghezza estesa della barra
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  top: -30, // Posiziona il cerchio leggermente sopra la dockbar
                  left: (dockBarWidth / 2) - 30, // Centra il cerchio rispetto alla dockbar
                  child: Image.asset(
                    'assets/dock_circle.png', // Immagine del cerchio
                    width: 60, // Larghezza del cerchio
                    height: 60, // Altezza del cerchio
                  ),
                ),
              ],
            ),
          ),
          // Icone dei pulsanti di navigazione
          SizedBox(
            height: 80, // Assicurati che la Dock Bar non copra il resto
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.broken_image_outlined,
                  index: 0,
                  touchController: touchController,
                ),
                _buildNavItem(
                  icon: Icons.rocket,
                  index: 1,
                  touchController: touchController,
                ),
                _buildNavItem(
                  icon: Icons.star,
                  index: 2,
                  touchController: touchController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Funzione per costruire gli elementi della navigazione
  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required TouchController touchController,
  }) {
    return GestureDetector(
      onTap: () {
        _onItemTapped(index);
        touchController.incrementTouches();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Durata dell'animazione
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              transform: Matrix4.translationValues(0, _selectedIndex == index ? -10 : 0, 0),
              child: Icon(
                icon,
                size: 36.0,
                color: _selectedIndex == index ? Colors.blue : Colors.black, // Cambia colore icona
              ),
            ),
          ],
        ),
      ),
    );
  }
}
