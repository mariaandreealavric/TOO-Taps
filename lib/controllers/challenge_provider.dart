import 'package:fingerfy/Models/profile_model.dart';
import 'package:flutter/material.dart';
import '../services/challenge_service.dart';


class ChallengeProvider with ChangeNotifier {
  final ChallengeService _challengeService = ChallengeService();
  DateTime? _startTime;
  ProfileModel? _challenger;
  ProfileModel? _opponent;

  DateTime? get startTime => _startTime;
  ProfileModel? get challenger => _challenger;
  ProfileModel? get opponent => _opponent;

  void startChallenge(ProfileModel challenger, ProfileModel opponent) {
    _challenger = challenger;
    _opponent = opponent;
    _startTime = DateTime.now();
    _challengeService.startChallenge(challenger, opponent);
    notifyListeners();
  }

  Future<void> completeChallenge() async {
    await _challengeService.completeChallenge();
    _challenger = null;
    _opponent = null;
    _startTime = null;
    notifyListeners();
  }

  bool isChallengeOngoing() {
    return _startTime != null;
  }

  bool isChallengeCompleted() {
    if (_startTime == null) return false;
    return DateTime.now().isAfter(_startTime!.add(const Duration(days: 7)));
  }
}
