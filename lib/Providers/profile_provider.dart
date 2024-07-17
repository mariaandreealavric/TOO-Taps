import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fingerfy/Models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProfileProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();  // Inizializza il logger

  ProfileModel? _profile;
  bool _isLoading = false;
  String _errorMessage = '';

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> ensureProfileExists(String uid) async {
    DocumentReference docRef = _firestore.collection('users').doc(uid);

    DocumentSnapshot doc = await docRef.get();
    if (!doc.exists) {
      _logger.i('Profile does not exist for user: $uid, creating a new one.');
      // Crea un profilo di esempio se non esiste
      await docRef.set({
        'displayName': 'John Doe',
        'email': 'johndoe@example.com',
        'photoUrl': 'https://example.com/default-photo.jpg',
        'touches': 0,
        'scrolls': 0,
        'trophies': [],
        'challenges': []
      });
    } else {
      _logger.i('Profile exists for user: $uid');
      // Verifica che tutti i campi siano presenti e aggiornali se necessario
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      bool updated = false;

      if (!data.containsKey('displayName')) {
        data['displayName'] = 'John Doe';
        updated = true;
      }
      if (!data.containsKey('email')) {
        data['email'] = 'johndoe@example.com';
        updated = true;
      }
      if (!data.containsKey('photoUrl')) {
        data['photoUrl'] = 'https://example.com/default-photo.jpg';
        updated = true;
      }
      if (!data.containsKey('touches')) {
        data['touches'] = 0;
        updated = true;
      }
      if (!data.containsKey('scrolls')) {
        data['scrolls'] = 0;
        updated = true;
      }
      if (!data.containsKey('trophies')) {
        data['trophies'] = [];
        updated = true;
      }
      if (!data.containsKey('challenges')) {
        data['challenges'] = [];
        updated = true;
      }

      if (updated) {
        await docRef.update(data);
        _logger.i('Profile fields updated successfully for user: $uid');
      } else {
        _logger.i('Profile already contains all required fields for user: $uid');
      }
    }
  }

  Future<void> startListening(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();
      _logger.i('Loading profile for user: $uid');

      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        _logger.i('Profile data retrieved: $data');

        // Verifica che tutti i campi necessari siano presenti
        final defaultData = {
          'displayName': 'User',
          'email': 'user@example.com',
          'photoUrl': 'https://example.com/default-photo.jpg',
          'touches': 0,
          'scrolls': 0,
          'trophies': [],
          'challenges': []
        };

        defaultData.forEach((key, value) {
          if (!data.containsKey(key)) {
            data[key] = value;
          }
        });

        _profile = ProfileModel.fromFirestore(data, snapshot.id);
        _errorMessage = '';
      } else {
        _profile = null;
        _errorMessage = 'Profilo non trovato';
        _logger.w('Profile not found for user: $uid');
      }
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
      await _firestore.collection('users').doc(profile.uid).update(profile.toFirestore());
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
      _firestore.collection('users').doc(_profile!.uid).update({
        'touches': FieldValue.increment(1),
      });
      notifyListeners();
    }
  }

  void incrementScrolls() {
    if (_profile != null) {
      _profile!.scrolls++;
      _firestore.collection('users').doc(_profile!.uid).update({
        'scrolls': FieldValue.increment(1),
      });
      notifyListeners();
    }
  }

  void addTrophy(String trophy) {
    if (_profile != null) {
      _profile!.trophies.add(trophy);
      _firestore.collection('users').doc(_profile!.uid).update({
        'trophies': _profile!.trophies,
      });
      notifyListeners();
    }
  }

  void addChallenge(Map<String, dynamic> challenge) {
    if (_profile != null) {
      _profile!.challenges.add(challenge);
      _firestore.collection('users').doc(_profile!.uid).update({
        'challenges': _profile!.challenges,
      });
      notifyListeners();
    }
  }
}
