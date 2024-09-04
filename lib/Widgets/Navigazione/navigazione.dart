// widgets/navigation.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/Contatori/touch_counter.dart';
import '../../models/profile_model.dart'; // Assicurati di importare il modello corretto

class Navigation extends StatelessWidget {
  final ProfileModel profile; // Aggiungi un parametro per il profilo utente

  const Navigation({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    // Inietta TouchController con il profilo utente corrente
    final touchController = Get.put(TouchController(profile));

    return Container(
      color: Colors.transparent,
      height: 90,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: touchController.incrementTouches, // Usa il metodo del controller
            child: IconButton(
              icon: const Icon(Icons.star, size: 36.0, color: Colors.white),
              onPressed: () {
                Get.toNamed('/classifica');
              },
            ),
          ),
          GestureDetector(
            onTap: touchController.incrementTouches, // Usa il metodo del controller
            child: IconButton(
              icon: const Icon(Icons.rocket, size: 36.0, color: Colors.white),
              onPressed: () {
                Get.toNamed('/scrollMeter');
              },
            ),
          ),
          GestureDetector(
            onTap: touchController.incrementTouches, // Usa il metodo del controller
            child: IconButton(
              icon: const Icon(Icons.broken_image_outlined, size: 36.0, color: Colors.white),
              onPressed: () {
                Get.toNamed('/imageList');
              },
            ),
          ),
        ],
      ),
    );
  }
}
