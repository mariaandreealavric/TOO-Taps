import 'package:fingerfy/Widgets/Navigazione/navigazione.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart'; // Usa il percorso coerente per il controller

class PodPage extends StatelessWidget {
  const PodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pod'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Il tuo Pod sta arrivando!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.blue,
              child: Obx(() {
                final profile = profileController.profile.value;
                if (profile == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Navigation(profile: profile);  // Assicurati di avere sempre un ritorno Widget
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
