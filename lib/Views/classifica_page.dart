import 'package:fingerfy/Models/profile_model.dart';
import 'package:fingerfy/Providers/Contatori/scroll_counter.dart';
import 'package:fingerfy/Widgets/Classifica%20widgets/card_altri.dart';
import 'package:fingerfy/Widgets/Classifica%20widgets/card_podio.dart';
import 'package:fingerfy/Widgets/Navigazione/navigazione.dart';
import 'package:fingerfy/Widgets/bottoni/bottone_profilo.dart';
import 'package:fingerfy/providers/theme_provider.dart';
import 'package:fingerfy/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ClassificaPage extends StatelessWidget {
  final String userID;

  const ClassificaPage({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final scrollCounter = Provider.of<ScrollCounter>(context);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        profileProvider.incrementTouches();
        profileProvider.updateProfile(profileProvider.profile!);
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: themeProvider.boxDecoration,
            ),
            Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Classifica',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  actions: const [
                    ProfileButton(),
                  ],
                  centerTitle: true,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .orderBy('touches', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(child: Text('Errore durante il caricamento dei dati'));
                      }

                      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;

                      return NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification) {
                            scrollCounter.incrementScrolls();
                          }
                          return true;
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(3),
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final userData = documents[index].data();
                            ProfileModel profile = ProfileModel.fromFirestore(userData, documents[index].id);

                            if (index < 3) {
                              return CardPodio(
                                numero: index,
                                profilo: profile,
                                opponent: _getOpponent(index, documents),
                              );
                            } else {
                              int opponentIndex = (index + 1) % documents.length;
                              final opponentData = documents[opponentIndex].data();
                              ProfileModel opponent = ProfileModel.fromFirestore(opponentData, documents[opponentIndex].id);

                              return CardAltri(
                                numero: index,
                                profilo: profile,
                                opponent: opponent,
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.blue,
                child: const Navigation(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ProfileModel _getOpponent(int index, List<QueryDocumentSnapshot<Map<String, dynamic>>> documents) {
    int opponentIndex = (index + 1) % documents.length;
    final opponentData = documents[opponentIndex].data();
    return ProfileModel.fromFirestore(opponentData, documents[opponentIndex].id);
  }
}
