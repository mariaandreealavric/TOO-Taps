//versione della navigation bar con tre immagini di dockbar,
//se non funziona, andare indietro una volta nella history.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/Contatori/touch_counter.dart';
import '../../models/profile_model.dart';
import '../bottoni/navigation_button.dart';

class Navigation extends StatefulWidget {
  final ProfileModel profile;

  const Navigation({super.key, required this.profile});

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  // Definisce le immagini della barra con incavi per i tre pulsanti
  final List<String> dockImages = [
    'assets/dockbar_left.png',   // Barra con incavo centrato sotto il primo pulsante
    'assets/dockbar_center.png', // Barra con incavo centrato sotto il secondo pulsante
    'assets/dockbar_right.png',  // Barra con incavo centrato sotto il terzo pulsante
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final touchController = Get.put(TouchController(widget.profile));

    return Positioned(
      bottom: 0, // Posiziona la barra di navigazione in basso
      left: 0,
      right: 0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // AnimatedSwitcher per cambiare le barre di navigazione
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300), // Durata dell'animazione
            child: Image.asset(
              dockImages[_selectedIndex], // Seleziona l'immagine della barra basata sull'indice selezionato
              key: ValueKey<int>(_selectedIndex), // Chiave unica per ogni immagine per l'AnimatedSwitcher
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width, // Larghezza della barra per coprire l'intera larghezza dello schermo
              height: 50, // Altezza della barra
            ),
          ),
          SizedBox(
            height: 90, // Assicurati che la Dock Bar non copra il resto
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavigationButton(
                  icon: Icons.broken_image_outlined,
                  index: 0,
                  routeName: '/taps_home',
                  isSelected: _selectedIndex == 0,
                  onTap: _onItemTapped,
                  touchController: touchController,
                  circleColor: Colors.red, // Colore del cerchio per il primo pulsante
                ),
                NavigationButton(
                  icon: Icons.rocket,
                  index: 1,
                  routeName: '/scrolling',
                  isSelected: _selectedIndex == 1,
                  onTap: _onItemTapped,
                  touchController: touchController,
                  circleColor: Colors.green, // Colore del cerchio per il secondo pulsante
                ),
                NavigationButton(
                  icon: Icons.star,
                  index: 2,
                  routeName: '/pod',
                  isSelected: _selectedIndex == 2,
                  onTap: _onItemTapped,
                  touchController: touchController,
                  circleColor: Colors.blue, // Colore del cerchio per il terzo pulsante
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
