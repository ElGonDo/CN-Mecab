// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnmecab/modules/publications/postPublications/services/uploadImage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<String> getImageUrl(String imageName) async {
  try {
    final Reference ref = storage.ref().child("post").child(imageName);
    return await ref.getDownloadURL();
  } catch (e) {
    // Manejar errores aquí, por ejemplo, la imagen no existe
    if (kDebugMode) {
      //print('Error obteniendo la URL de la imagen: $e');
    }
    return ''; // Puedes devolver una URL predeterminada o nula
  }
}

// ignore: non_constant_identifier_names
Future<String> Publicaciones_Resenables(
  String titulo,
  String descripcion,
  String director,
  String productor,
  String guionista,
  String distribuidor,
  String compania,
  String clasificacion,
  String idioma,
  String fechaEstreno,
  String duracion,
  String selectedCategory,
  List<String> generos,
  String? collectionName,
) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Utiliza el UID del usuario como nombre de documento
    final documentReference =
        db.collection('Publicaciones_Reseñables').doc(user.uid);
    final postId = DateTime.now().millisecondsSinceEpoch.toString();
    final postData = {
      "Titulo": titulo,
      "Descripcion": descripcion,
      "Director": director,
      "Productor": productor,
      "Guionista": guionista,
      "Distribuidor": distribuidor,
      "Compania": compania,
      "Clasificacion": clasificacion,
      "Idioma": idioma,
      "FechaEstreno": fechaEstreno,
      "Duracion": duracion,
      "Categoria": selectedCategory,
      'generos': generos,
      "FechaHora": FieldValue.serverTimestamp(),
    };
    await documentReference.set(
      {postId: postData},
      SetOptions(merge: true),
    );
    return postId; // Devuelve la ID de la publicación
  }

  return ''; // Devuelve un valor por defecto en caso de error o si el usuario es nulo
}

// ignore: non_constant_identifier_names
Future<String> Publicaciones_No_Resenables(
  String titulo,
  String descripcion,
  String selectedCategory,
  List<String> generos,
) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Utiliza el UID del usuario como nombre de documento
    final documentReference =
        db.collection('Publicaciones_No_Reseñables').doc(user.uid);
    final postId = DateTime.now().millisecondsSinceEpoch.toString();
    final postData = {
      "Titulo": titulo,
      "Descripcion": descripcion,
      "Categoria": selectedCategory,
      'generos': generos,
      "FechaHora": FieldValue.serverTimestamp(),
    };
    await documentReference.set(
      {postId: postData},
      SetOptions(merge: true),
    );
    return postId; // Devuelve la ID de la publicación
  }

  return ''; // Devuelve un valor por defecto en caso de error o si el usuario es nulo
}
