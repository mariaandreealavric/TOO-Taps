import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Logger _logger = Logger();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  Future<void> signUpWithEmailAndPassword(String email, String password, String name, File image) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        String imageUrl = await uploadProfileImage(user.uid, image);
        await addUserData(user.uid, email, name, imageUrl);
      }
    } catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> addUserData(String uid, String email, String nome, String imageUrl) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'displayName': nome,
      'photoUrl': imageUrl,
      'touches': 0,
      'scrolls': 0,
      'trophies': [],
      'challenges': [],
    });
  }

  Future<String> uploadProfileImage(String uid, File image) async {
    try {
      TaskSnapshot snapshot = await _storage.ref('profileImages/$uid').putFile(image);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) {
    return _firestore.collection('users').doc(uid).get();
  }
}
