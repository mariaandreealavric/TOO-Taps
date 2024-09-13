//mport 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fingerfy/models/profile_model.dart';

import 'package:flutter/material.dart';


class ScrollCounter with ChangeNotifier {
  ProfileModel _userProfile;

  ScrollCounter(this._userProfile);

  int get scrolls => _userProfile.scrolls;

  void updateProfile(ProfileModel profile) {
    _userProfile = profile;
  }

  void incrementScrolls() {
    _userProfile.scrolls++;
    notifyListeners();
    //_updateProfileData();
  }

  //Future<void> _updateProfileData() async {
  //  try {
  //    await FirebaseFirestore.instance.collection('users').doc(_userProfile.uid).update({
  //      'scrolls': _userProfile.scrolls,
  //    });
  //  } catch (e) {
      // Gestisci l'errore, ad esempio loggandolo o mostrando un messaggio all'utente
  //  }
//  }
}
