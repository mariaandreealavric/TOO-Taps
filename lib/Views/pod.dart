import 'package:fingerfy/Widgets/Navigazione/navigazione.dart';
import 'package:flutter/material.dart';
import 'package:fingerfy/models/profile_model.dart'; // Assicurati di importare il modello

class PodPage extends StatelessWidget {
  const PodPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simuliamo un profilo utente per l'esempio
    final profile = ProfileModel(
      uid: '12345',
      displayName: 'User',
      email: 'user@example.com',
      photoUrl: 'https://example.com/photo.jpg',
      touches: 0,
      scrolls: 0,
      trophies: [],
      challenges: [],
    );

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
              child: Navigation(profile: profile), // Passa il profilo richiesto
            ),
          ),
        ],
      ),
    );
  }
}
