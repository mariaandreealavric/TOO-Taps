import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fingerfy/Models/profile_model.dart';
import 'package:flutter/material.dart';


class TouchCounter with ChangeNotifier {
  ProfileModel _userProfile;

  TouchCounter(this._userProfile);

  int get count => _userProfile.touches;

  void updateProfile(ProfileModel profile) {
    _userProfile = profile;
  }

  void incrementTouches() {
    _userProfile.touches++;
    notifyListeners();
    _updateProfileData();
  }

  Future<void> _updateProfileData() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(_userProfile.uid).update({
        'touches': _userProfile.touches,
      });
    } catch (e) {
      // Gestisci l'errore, ad esempio loggandolo o mostrando un messaggio all'utente
    }
  }
}
