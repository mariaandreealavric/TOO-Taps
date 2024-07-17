import 'package:flutter/material.dart';
import 'package:fingerfy/Models/profile_model.dart';
import 'package:fingerfy/Widgets/bottoni/challenge_button.dart';
import 'dart:ui';

class CardPodio extends StatelessWidget {
  final int numero;
  final ProfileModel profilo;
  final ProfileModel opponent;

  const CardPodio({super.key, required this.numero, required this.profilo, required this.opponent});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (numero == 0) {
      backgroundColor = Colors.amber.withOpacity(0.1);
    } else if (numero == 1) {
      backgroundColor = Colors.grey[400]!.withOpacity(0.1);
    } else if (numero == 2) {
      backgroundColor = Colors.brown.withOpacity(0.1);
    } else {
      backgroundColor = Colors.white.withOpacity(0.1);
    }

    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 100,
                  padding: const EdgeInsets.only(left: 40, right: 20, bottom: 40, top: 40),
                  child: Text(
                    '${numero + 1}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      '${numero + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profilo.displayName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Tocchi: ${profilo.touches}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ChallengeButton(challenger: profilo, opponent: opponent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
