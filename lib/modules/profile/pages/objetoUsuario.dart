// ignore_for_file: avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class UserProfile {
  final String uid;
  final String role;
  final String name;
  String? profileImageURL; // Nueva adición para la URL de la imagen de perfil

  UserProfile(
      {required this.uid,
      required this.role,
      required this.name,
      this.profileImageURL});

  UserProfile copyWith({String? profileImageURL}) {
    return UserProfile(
      uid: uid,
      role: role,
      name: name,
      profileImageURL: profileImageURL ??
          this.profileImageURL, // Actualiza imagenURL si se proporciona, de lo contrario mantiene el mismo valor
    );
  }
}

class UserProfileSingleton {
  UserProfile? _userProfile;
  static final UserProfileSingleton _instance =
      UserProfileSingleton._internal();

  factory UserProfileSingleton() {
    return _instance;
  }

  UserProfile? get userProfile => _userProfile;

  Future<UserProfile?> initializeUserProfile({String? uid}) async {
    try {
      String userId = uid ?? FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(userId)
          .get();
      Map<String, dynamic> userData =
          userProfileSnapshot.data() as Map<String, dynamic>;
      UserProfile userProfile = UserProfile(
          uid: userId, role: userData['Rol'], name: userData['Nombre']);

      String? profileImageName =
          await getProfileImageName(userId, userData['Rol']);

      if (profileImageName != null) {
        String imageURL =
            await getImageURLByName(profileImageName, userData['Rol']);

        // Actualiza el UserProfile con la nueva URL de la imagen si se encuentra
        userProfile = userProfile.copyWith(profileImageURL: imageURL);
      }

      // Imprime la UID, el rol y la URL de la imagen en la consola
      print('Objeto UID: ${userProfile.uid}');
      print('Objeto Rol: ${userProfile.role}');
      print('Objeto Name: ${userProfile.name}');
      print('Objeto ProfileImageURL: ${userProfile.profileImageURL}');

      return userProfile;
    } catch (e) {
      print('Error fetching user profile: $e');
    }

    return null;
  }

  // Método para obtener la URL de la imagen por nombre y rol
  Future<String> getImageURLByName(String imageName, String role) async {
    String folder;
    if (role == 'Visitante') {
      folder = 'profileV';
    } else if (role == 'Creador') {
      folder = 'profileC';
    } else if (role == 'Promotora') {
      folder = 'profileP';
    } else {
      throw Exception('Rol de usuario no válido');
    }
    String imageURL = await getImageURLFromFolder(folder, imageName);
    return imageURL;
  }

  // Método para obtener el nombre de la imagen de perfil del usuario
  Future<String?> getProfileImageName(String uid, String role) async {
    if (role == 'Visitante') {
      return await getVisitorProfileImageName(uid);
    } else {
      return uid; // El nombre de la imagen es el UID del usuario para Creadores y Promotoras
    }
  }

  // Método para obtener la URL de la imagen desde la carpeta correspondiente
  Future<String> getImageURLFromFolder(String folder, String imageName) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference ref = storage.ref().child(folder).child('$imageName.jpg');
      return await ref.getDownloadURL();
    } catch (e) {
      // Manejar errores aquí, por ejemplo, la imagen no existe
      if (kDebugMode) {
        print('Error obteniendo la URL de la imagen: $e');
      }
      return ''; // Puedes devolver una URL predeterminada o nula
    }
  }

  // Método para obtener el nombre de la imagen de perfil del visitante
  Future<String?> getVisitorProfileImageName(String uid) async {
    try {
      DocumentSnapshot visitorProfileSnapshot = await FirebaseFirestore.instance
          .collection('Visitantes')
          .doc(uid)
          .get();
      Map<String, dynamic> visitorData =
          visitorProfileSnapshot.data() as Map<String, dynamic>;

      String? profileImageName = visitorData['ImagenPerfil'];
      return profileImageName;
    } catch (e) {
      print('Error fetching visitor profile image: $e');
      return null;
    }
  }

  UserProfileSingleton._internal();
}
