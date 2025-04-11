<<<<<<< HEAD
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:material_hub/user_type/user_type.dart';

class CustomUser {
  CustomUser({
    this.displayName,
    this.photoUrl,
    required this.uid,
    this.email,
  });

  final String? displayName;
  final String? photoUrl;
  final String uid;
  final String? email;
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

abstract class AuthBase {
  Stream<CustomUser?> get onAuthStateChanged;
  Future<CustomUser?> currentUser();
  Future<void> signOut();
  Future<void> setUserRole(String userId, UserType role);
  Future<CustomUser?> signInWithGoogle();
  Future<UserType> getUserRole(String uid);
  Future<CustomUser?> signInWithEmailAndPassword(String email, String password);
  Future<CustomUser?> createUserWithEmailAndPassword(
      String email, String password, UserType role);
  Future<void> updateProfilePicture(String uid, String photoUrl);
  Future<String> uploadProfilePicture(String uid, String filepath);
  Future<String> uploadAndSaveProfilePicture(String uid, String filepath);
}

class Auth implements AuthBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  CustomUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return CustomUser(
      displayName: user.displayName,
      photoUrl: user.photoURL,
      uid: user.uid,
      email: user.email,
    );
  }

  @override
  Stream<CustomUser?> get onAuthStateChanged {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<void> setUserRole(String userId, UserType role) async {
    await _firestore.collection('user_data').doc(userId).set({
      'role': role.toString().split('.').last,
      'createdAT': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<CustomUser?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authresult = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return _userFromFirebase(authresult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<CustomUser?> currentUser() async {
    final user = _auth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<CustomUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(authResult.user);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
  }

  @override
  Future<CustomUser?> createUserWithEmailAndPassword(
      String email, String password, UserType role) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (authResult.user != null) {
        await setUserRole(authResult.user!.uid, role);
      }
      return _userFromFirebase(authResult.user);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
  }

  @override
  Future<UserType> getUserRole(String uid) async {
    final doc = await _firestore.collection('user_data').doc(uid).get();
    final roleString = doc['role'] as String;
    return UserType.values
        .firstWhere((e) => e.toString().split('.').last == roleString);
  }

// Upload profile picture to Firebase Storage
  @override
  Future<String> uploadProfilePicture(String uid, String filepath) async {
    try {
      final ref = _storage.ref().child('profile_pictures').child(uid);
      // `putFile` returns an `UploadTask`, which can be used to track the upload status
      final uploadTask = ref.putFile(File(filepath));

      // Wait for the task to complete
      final snapshot = await uploadTask.whenComplete(() => {});

      // Get the download URL of the uploaded file
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile picture');
    }
  }

  @override
  // Update user's profile picture in Firestore and Firebase Auth
  Future<void> updateProfilePicture(String uid, String photoUrl) async {
    try {
      // Update Firestore with the new photo URL
      await _firestore
          .collection('user_data')
          .doc(uid)
          .update({'photoUrl': photoUrl});

      // Update Firebase Auth user's profile
      final user = _auth.currentUser;
      await user?.updatePhotoURL(photoUrl);
    } catch (e) {
      throw Exception('Failed to update profile picture');
    }
  }

  // Upload and save profile picture to Firestore and Firebase Storage
  @override
  Future<String> uploadAndSaveProfilePicture(
      String uid, String filepath) async {
    try {
      // Upload the profile picture and get the download URL
      final downloadUrl = await uploadProfilePicture(uid, filepath);

      // Update Firestore and Auth with the new photo URL
      await updateProfilePicture(uid, downloadUrl);

      // Return the download URL
      return downloadUrl;
    } catch (e) {
      print('Error in uploadAndSaveProfilePicture: $e');
      throw Exception('Failed to upload and save profile picture');
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
=======
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:material_hub/user_type/user_type.dart';

class CustomUser {
  CustomUser({
    this.displayName,
    this.photoUrl,
    required this.uid,
    this.email,
  });

  final String? displayName;
  final String? photoUrl;
  final String uid;
  final String? email;
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

abstract class AuthBase {
  Stream<CustomUser?> get onAuthStateChanged;
  Future<CustomUser?> currentUser();
  Future<void> signOut();
  Future<void> setUserRole(String userId, UserType role);
  Future<CustomUser?> signInWithGoogle();
  Future<UserType> getUserRole(String uid);
  Future<CustomUser?> signInWithEmailAndPassword(String email, String password);
  Future<CustomUser?> createUserWithEmailAndPassword(
      String email, String password, UserType role);
  Future<void> updateProfilePicture(String uid, String photoUrl);
  Future<String> uploadProfilePicture(String uid, String filepath);
  Future<String> uploadAndSaveProfilePicture(String uid, String filepath);
}

class Auth implements AuthBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  CustomUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return CustomUser(
      displayName: user.displayName,
      photoUrl: user.photoURL,
      uid: user.uid,
      email: user.email,
    );
  }

  @override
  Stream<CustomUser?> get onAuthStateChanged {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<void> setUserRole(String userId, UserType role) async {
    await _firestore.collection('user_data').doc(userId).set({
      'role': role.toString().split('.').last,
      'createdAT': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<CustomUser?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authresult = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return _userFromFirebase(authresult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<CustomUser?> currentUser() async {
    final user = _auth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<CustomUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(authResult.user);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
  }

  @override
  Future<CustomUser?> createUserWithEmailAndPassword(
      String email, String password, UserType role) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (authResult.user != null) {
        await setUserRole(authResult.user!.uid, role);
      }
      return _userFromFirebase(authResult.user);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
  }

  @override
  Future<UserType> getUserRole(String uid) async {
    final doc = await _firestore.collection('user_data').doc(uid).get();
    final roleString = doc['role'] as String;
    return UserType.values
        .firstWhere((e) => e.toString().split('.').last == roleString);
  }

// Upload profile picture to Firebase Storage
  @override
  Future<String> uploadProfilePicture(String uid, String filepath) async {
    try {
      final ref = _storage.ref().child('profile_pictures').child(uid);
      // `putFile` returns an `UploadTask`, which can be used to track the upload status
      final uploadTask = ref.putFile(File(filepath));

      // Wait for the task to complete
      final snapshot = await uploadTask.whenComplete(() => {});

      // Get the download URL of the uploaded file
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile picture');
    }
  }

  @override
  // Update user's profile picture in Firestore and Firebase Auth
  Future<void> updateProfilePicture(String uid, String photoUrl) async {
    try {
      // Update Firestore with the new photo URL
      await _firestore
          .collection('user_data')
          .doc(uid)
          .update({'photoUrl': photoUrl});

      // Update Firebase Auth user's profile
      final user = _auth.currentUser;
      await user?.updatePhotoURL(photoUrl);
    } catch (e) {
      throw Exception('Failed to update profile picture');
    }
  }

  // Upload and save profile picture to Firestore and Firebase Storage
  @override
  Future<String> uploadAndSaveProfilePicture(
      String uid, String filepath) async {
    try {
      // Upload the profile picture and get the download URL
      final downloadUrl = await uploadProfilePicture(uid, filepath);

      // Update Firestore and Auth with the new photo URL
      await updateProfilePicture(uid, downloadUrl);

      // Return the download URL
      return downloadUrl;
    } catch (e) {
      print('Error in uploadAndSaveProfilePicture: $e');
      throw Exception('Failed to upload and save profile picture');
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
>>>>>>> 8ddb56bed4ea68597595ff99aef8608671358442
