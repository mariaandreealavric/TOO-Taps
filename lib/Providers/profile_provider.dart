import 'package:fingerfy/Models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// Mock data for demonstration purposes
final mockProfileData = {
  'displayName': 'Mock User',
  'email': 'mockuser@example.com',
  'photoUrl': 'https://example.com/default-photo.jpg',
  'touches': 0,
  'scrolls': 0,
  'trophies': [],
  'challenges': []
};

class ProfileProvider with ChangeNotifier {
  final Logger _logger = Logger();  // Inizializza il logger

  ProfileModel? _profile;
  bool _isLoading = false;
  String _errorMessage = '';

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Method to set mock profile data
  void setMockProfile(String uid) {
    _logger.i('Using mock data for profile: $uid');
    _profile = ProfileModel.fromFirestore(mockProfileData, uid);
    notifyListeners();
  }

  Future<void> ensureProfileExists(String uid) async {
    _logger.i('Using mock data for profile: $uid');
    await Future.delayed(const Duration(seconds: 1));
    _profile = ProfileModel.fromFirestore(mockProfileData, uid);
    notifyListeners();
  }

  Future<void> startListening(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();
      _logger.i('Loading mock profile for user: $uid');

      await Future.delayed(const Duration(seconds: 1));

      _profile = ProfileModel.fromFirestore(mockProfileData, uid);
      _errorMessage = '';

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Errore nel caricamento del profilo: $e';
      _isLoading = false;
      _logger.e('Error loading profile: $e');
      notifyListeners();
    }
  }

  Future<void> updateProfile(ProfileModel profile) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _profile = profile;
    } catch (e) {
      _errorMessage = 'Errore durante l\'aggiornamento del profilo';
      _logger.e('Error updating profile: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void incrementTouches() {
    if (_profile != null) {
      _profile!.touches++;
      notifyListeners();
    }
  }

  void incrementScrolls() {
    if (_profile != null) {
      _profile!.scrolls++;
      notifyListeners();
    }
  }

  void addTrophy(String trophy) {
    if (_profile != null) {
      _profile!.trophies.add(trophy);
      notifyListeners();
    }
  }

  void addChallenge(Map<String, dynamic> challenge) {
    if (_profile != null) {
      _profile!.challenges.add(challenge);
      notifyListeners();
    }
  }
}
