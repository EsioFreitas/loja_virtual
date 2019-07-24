import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  bool isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUseer();
  }

  void singUp({@required Map<String, dynamic> userData,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
        email: userData['email'], password: pass)
        .then((user) async {
      firebaseUser = user;
      onSuccess();
      await _saveDataUser(userData);
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn({@required String email,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    _auth.signInWithEmailAndPassword(email: email, password: pass).then((
        user) async {
      firebaseUser = user;
      await _loadCurrentUseer();
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> _saveDataUser(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .setData(userData);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future sigOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  Future<Null> _loadCurrentUseer() async {
    if (firebaseUser == null) {
      firebaseUser = await _auth.currentUser();
    }
    if (firebaseUser != null) {
      if (userData['name'] == null) {
        DocumentSnapshot doc = await Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .get();
        userData = doc.data;
      }
    }

    notifyListeners();
  }

//bool isLoggedIn() {}
}
