// ignore_for_file: unnecessary_null_comparison, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnmecab/modules/publications/postPublications/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<int> actualizarLikes(String pubId) async {
  final user = FirebaseAuth.instance.currentUser;
  int likes = 0;

  if (user != null) {
    final reaccionesDocumentReference = db.collection('Reacciones').doc(pubId);
    final reaccionesDocument = await reaccionesDocumentReference.get();
    Map<String, dynamic> reaccionesData;
    if (!reaccionesDocument.exists) {
      reaccionesData = {};
    } else {
      reaccionesData = reaccionesDocument.data() as Map<String, dynamic>;
    }

    if (reaccionesData != null && pubId != null) {
      int likes = reaccionesData['likes'] ?? 0;

      List<dynamic> usuariosQueDieronLikeDynamic =
          reaccionesData['usuarios_que_dieron_like'] ?? [];

      List<String> usuariosQueDieronLike =
          usuariosQueDieronLikeDynamic.cast<String>();

      if (usuariosQueDieronLike.contains(user.uid)) {
        // El usuario ya dio like, entonces se quitará
        likes--;
        usuariosQueDieronLike.remove(user.uid);
      } else {
        // El usuario no había dado like, entonces se agregará
        likes++;
        usuariosQueDieronLike.add(user.uid);
      }

      reaccionesData = {
        'likes': likes,
        'usuarios_que_dieron_like': usuariosQueDieronLike,
      };

      await reaccionesDocumentReference.set(
          reaccionesData, SetOptions(merge: true));

      return likes; // Devuelve el nuevo contador de likes
    }
  }
  return likes; // Devuelve el contador actual de likes si no se realizó ningún cambio
}

void actualizarRating(String pubId, double rating) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Obtener la referencia del documento en la colección de Reseñas
    final reseniasDocumentReference =
        FirebaseFirestore.instance.collection('Reseñas').doc(pubId);
    final reseniasDocument = await reseniasDocumentReference.get();
    Map<String, dynamic> reseniasData;
    if (!reseniasDocument.exists) {
      // Si el documento no existe, inicializamos el mapa con la calificación actual y la ID del usuario
      reseniasData = {
        'calificaciones': {
          user.uid: rating,
        }
      };
    } else {
      // Si el documento ya existe, obtenemos los datos actuales del documento
      reseniasData = reseniasDocument.data() as Map<String, dynamic>;
      // Actualizamos el mapa con la calificación actual del usuario
      reseniasData['calificaciones'][user.uid] = rating;
    }

    // Calcular el promedio de las calificaciones
    double sumaCalificaciones = reseniasData['calificaciones']
        .values
        .reduce((value, element) => value + element);
    int cantidadCalificaciones = reseniasData['calificaciones'].length;
    double promedioCalificaciones = sumaCalificaciones / cantidadCalificaciones;

    // Actualizamos el mapa con el promedio de las calificaciones
    reseniasData['promedio'] = promedioCalificaciones;

    // Actualizamos el documento en la base de datos
    await reseniasDocumentReference.set(reseniasData, SetOptions(merge: true));
  } else {
    // Si el usuario no está autenticado, muestra un mensaje o toma otra acción según tus necesidades
    if (kDebugMode) {
      print('El usuario no está autenticado.');
    }
  }
}
