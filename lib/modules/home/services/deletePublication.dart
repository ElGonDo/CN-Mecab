// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> eliminarPublicacion(String uid, String pubID) async {
  final firestoreInstance = FirebaseFirestore.instance;

  try {
    // Eliminar la publicación de Firestore
    await firestoreInstance.collection('Publicaciones_Reseñables').doc(uid).update({
      pubID: FieldValue.delete(),
    });
    return true; // La eliminación fue exitosa
  } catch (e) {
    print('Error al eliminar la publicación: $e');
    return false; // Hubo un error al eliminar la publicación
  }
}


Future<bool> eliminarPublicacionNoResenable(String uid, String pubID) async {
  final firestoreInstance = FirebaseFirestore.instance;

  try {
    // Eliminar la publicación de Firestore
    await firestoreInstance
        .collection('Publicaciones_No_Reseñables')
        .doc(uid)
        .update({
      pubID: FieldValue.delete(),
    });
    return true; // La eliminación fue exitosa
  } catch (e) {
    print('Error al eliminar la publicación: $e');
    return false; // Hubo un error al eliminar la publicación
  }
}
