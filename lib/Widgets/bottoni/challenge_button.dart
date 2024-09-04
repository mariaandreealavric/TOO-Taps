import 'package:fingerfy/models/profile_model.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/challenge_provider.dart';

class ChallengeButton extends StatelessWidget {
  final ProfileModel challenger;
  final ProfileModel opponent;

  const ChallengeButton({super.key, required this.challenger, required this.opponent});

  @override
  Widget build(BuildContext context) {
    final challengeProvider = Provider.of<ChallengeController>(context);
    bool isOngoing = challengeProvider.isChallengeOngoing();

    return IconButton(
      icon: Icon(
        Icons.sports_kabaddi,
        color: isOngoing ? Colors.red : Colors.white,
      ),
      onPressed: () {
        if (!isOngoing) {
          challengeProvider.startChallenge(challenger, opponent);

          // Schedule challenge completion after 7 days
          Future.delayed(const Duration(days: 7), () async {
            await challengeProvider.completeChallenge();
            if (challengeProvider.isChallengeCompleted()) {
              // Update the state or notify the UI as needed
            }
          });
        }
      },
    );
  }
}
