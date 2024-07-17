import 'package:fingerfy/providers/challenge_provider.dart';
import 'package:fingerfy/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengePage extends StatelessWidget {
  final String userID;

  const ChallengePage({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    final challengeProvider = Provider.of<ChallengeProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sfide'),
      ),
      body: ListView.builder(
        itemCount: profileProvider.profile?.challenges.length ?? 0,
        itemBuilder: (context, index) {
          final challenge = profileProvider.profile!.challenges[index];
          final isChallenger = challenge['challengerUid'] == userID;
          final opponentUid = isChallenger ? challenge['opponentUid'] : challenge['challengerUid'];
          final opponentTouches = isChallenger ? challenge['opponentTouches'] : challenge['challengerTouches'];
          final opponentScrolls = isChallenger ? challenge['opponentScrolls'] : challenge['challengerScrolls'];
          final userTouches = isChallenger ? challenge['challengerTouches'] : challenge['opponentTouches'];
          final userScrolls = isChallenger ? challenge['challengerScrolls'] : challenge['opponentScrolls'];

          return ListTile(
            title: Text('Sfida con $opponentUid'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Inizio: ${challenge['startDate'].toDate()} - Fine: ${challenge['endDate'].toDate()}'),
                Text('I tuoi tocchi: $userTouches, I tuoi scrolls: $userScrolls'),
                Text('Tocchi avversario: $opponentTouches, Scrolls avversario: $opponentScrolls'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                await challengeProvider.completeChallenge();
                profileProvider.startListening(userID); // Ricarica il profilo in tempo reale
              },
            ),
          );
        },
      ),
    );
  }
}
