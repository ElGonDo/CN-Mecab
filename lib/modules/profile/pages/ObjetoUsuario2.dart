// ignore_for_file: file_names, avoid_print, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, unused_element
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileUser {
  final String uid;
  final String rol;
  final String nombre;
  final String? imagenURL;

  ProfileUser({
    required this.uid,
    required this.rol,
    required this.nombre,
    this.imagenURL,
  });
  ProfileUser copyWith({String? imagenURL}) {
    return ProfileUser(
      uid: uid,
      rol: rol,
      nombre: nombre,
      imagenURL: imagenURL ??
          this.imagenURL, // Actualiza imagenURL si se proporciona, de lo contrario mantiene el mismo valor
    );
  }
}

final profileUserProvider = StateProvider<ProfileUser?>((ref) => null);

void clearProfileUser(StateController<ProfileUser?> profileUserController) {
  profileUserController.state = null;
}

// Esta es tu función original para inicializar el objeto ProfileUser
Future<void> initializeProfileUser(
    StateController<ProfileUser?> profileUserController) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(user.uid)
          .get();
      Map<String, dynamic> userData =
          userProfileSnapshot.data() as Map<String, dynamic>;

      ProfileUser _profileUser = ProfileUser(
          uid: user.uid,
          rol: userData['Rol'],
          nombre: userData['Nombre'],
          imagenURL: null);
      String? profileImageName =
          await getProfileImageName(user.uid, userData['Rol']);
      if (profileImageName != null) {
        String imageURL =
            await getImageURLByName(profileImageName, userData['Rol']);
        _profileUser = _profileUser.copyWith(
            imagenURL: imageURL); // Actualiza imagenURL si se encuentra la URL
      }

      profileUserController.state = _profileUser;

      print('Objeto UID: ${_profileUser.uid}');
      print('Objeto Rol: ${_profileUser.rol}');
      print('Objeto Name: ${_profileUser.nombre}');
      print('Objeto ProfileImageURL: ${_profileUser.imagenURL}');
    }
  } catch (e) {
    print('Error fetching user profile: $e');
  }
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
    if (kDebugMode) {
      print('Error fetching visitor profile image: $e');
    }
    return null;
  }
}
