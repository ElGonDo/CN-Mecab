// ignore_for_file: avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile {
  final String uid;
  final String role;

  UserProfile({required this.uid, required this.role});
}

class UserProfileSingleton {
  UserProfile? _userProfile;
  static final UserProfileSingleton _instance =
      UserProfileSingleton._internal();

  factory UserProfileSingleton() {
    return _instance;
  }

  UserProfile? get userProfile => _userProfile;

  Future<UserProfile?> initializeUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(user.uid)
            .get();
        Map<String, dynamic> userData =
            userProfileSnapshot.data() as Map<String, dynamic>;

        _userProfile = UserProfile(
          uid: user.uid,
          role: userData['Rol'],
        );
        // Imprime la UID y el rol en la consola
        print('UID: ${_userProfile?.uid}');
        print('Rol: ${_userProfile?.role}');
        return _userProfile;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
    return null;
  }

  UserProfileSingleton._internal();
}
