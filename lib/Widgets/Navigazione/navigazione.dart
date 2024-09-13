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
    0.1, // Posizione del primo pulsante
    0.45, // Posizione del secondo pulsante (centro)
    0.8, // Posizione del terzo pulsante
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final touchController = Get.put(TouchController(widget.profile));
    double width = MediaQuery
        .of(context)
        .size
        .width;

    // Calcolo della posizione orizzontale dinamica per il cerchio e la dockbar
    double dockBarWidth = width * 1.6; // Larghezza estesa della dockbar
    double circlePosition = width *
        positions[_selectedIndex]; // Posizione orizzontale del cerchio

    return Positioned(
      bottom: 0, // Posiziona la barra di navigazione in basso
      left: 0,
      right: 0,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Dockbar e dock circle si muovono insieme
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            // Durata dell'animazione
            left: circlePosition - (dockBarWidth / 2.2),
            // Centra la dockbar rispetto all'icona selezionata
            bottom: 0,
            // Posizione della dockbar
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              // Permette al cerchio di essere visibile anche se esce dai limiti
              children: [
                Image.asset(
                  'assets/dockbar.png', // Immagine della dockbar
                  width: dockBarWidth, // Larghezza estesa della barra
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  top: -3,
                  // Posiziona il cerchio leggermente sopra la dockbar
                  left: (dockBarWidth / 2) - 30,
                  // Centra il cerchio rispetto alla dockbar
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
            height: 104, // Assicurati che la Dock Bar non copra il resto
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  inactiveImage: 'assets/sezione_tap.png',
                  activeImage: 'assets/sezione_tap_active.png',
                  index: 0,
                  touchController: touchController,
                ),
                _buildNavItem(
                  inactiveImage: 'assets/sezione_scroll.png',
                  activeImage: 'assets/sezione_scroll_active.png',
                  index: 1,
                  touchController: touchController,
                ),
                _buildNavItem(
                  inactiveImage: 'assets/sezione_pod.png',
                  activeImage: 'assets/sezione_pod_active.png',
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
    required String inactiveImage,
    required String activeImage,
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
              transform: Matrix4.translationValues(
                  0, _selectedIndex == index ? -10 : 0, 0),
              child: Image.asset(
                _selectedIndex == index ? activeImage : inactiveImage,
                // Scegli l'immagine in base allo stato
                width: 36.0, // Regola la dimensione dell'immagine
                height: 36.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
