import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/profile_model.dart';

final mockProfileData = {
  'displayName': 'Mock User',
  'email': 'mockuser@example.com',
  'photoUrl': 'https://example.com/default-photo.jpg',
  'touches': 0,
  'scrolls': 0,
  'trophies': [],
  'challenges': []
};

class ProfileController extends GetxController {
  final Logger _logger = Logger();
  var profile = Rx<ProfileModel?>(null);
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  void setMockProfile(String uid) {
    _logger.i('Using mock data for profile: $uid');
    profile.value = ProfileModel.fromFirestore(mockProfileData, uid);
  }

  Future<void> ensureProfileExists(String uid) async {
    _logger.i('Ensuring profile exists for user: $uid');
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    profile.value = ProfileModel.fromFirestore(mockProfileData, uid);
    isLoading.value = false;
  }

  Future<void> updateProfile(ProfileModel updatedProfile) async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      profile.value = updatedProfile;
    } catch (e) {
      errorMessage.value = 'Errore durante l\'aggiornamento del profilo';
      _logger.e('Error updating profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void incrementTouches() {
    if (profile.value != null) {
      profile.value!.touches++;
      profile.refresh();
    }
  }

  void incrementScrolls() {
    if (profile.value != null) {
      profile.value!.scrolls++;
      profile.refresh();
    }
  }

  void addTrophy(String trophy) {
    if (profile.value != null) {
      profile.value!.trophies.add(trophy);
      profile.refresh();
    }
  }

  void addChallenge(Map<String, dynamic> challenge) {
    if (profile.value != null) {
      profile.value!.challenges.add(challenge);
      profile.refresh();
    }
  }
}
