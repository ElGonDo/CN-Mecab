// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Publicacion {
  final String categoria;
  final String descripcion;
  final List<String> rgenero;
  final String titulo;
  final String uid;
  final String pubID;
  final bool esResenable;
  int likes;

  Publicacion({
    required this.categoria,
    required this.descripcion,
    required this.rgenero,
    required this.titulo,
    required this.uid,
    required this.pubID,
    required this.esResenable,
    required this.likes,
  });

  get usuariosQueDieronLike => null;
}

Future<List<Publicacion>> obtenerDatos() async {
  final firestoreInstance = FirebaseFirestore.instance;
  List<Publicacion> publicacionesList = [];

  QuerySnapshot querySnapshot =
      await firestoreInstance.collection('Publicaciones_No_Reseñables').get();

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    String uid = doc.id;
    Map<String, dynamic> publicaciones = doc.data() as Map<String, dynamic>;

    publicaciones.forEach((pubID, value) {
      Map<String, dynamic> publicacion = value as Map<String, dynamic>;

      String categoria = publicacion['Categoria'];
      String descripcion = publicacion['Descripcion'];
      List<String> rgenero = List<String>.from(publicacion['generos']);
      String titulo = publicacion['Titulo'];
      bool esResenable = publicacion['Reseñable'] ?? false;

      Publicacion nuevaPublicacion = Publicacion(
        categoria: categoria,
        descripcion: descripcion,
        rgenero: rgenero,
        titulo: titulo,
        uid: uid,
        pubID: pubID,
        esResenable: esResenable,
        likes: 0,
      );
      publicacionesList.add(nuevaPublicacion);
    });
  }
  for (Publicacion publicacion in publicacionesList) {
    DocumentSnapshot reaccionesDoc = await firestoreInstance
        .collection('Reacciones')
        .doc(publicacion.pubID)
        .get();
    if (reaccionesDoc.exists) {
      Map<String, dynamic> reaccionesData =
          reaccionesDoc.data() as Map<String, dynamic>;
      if (reaccionesData.containsKey('likes')) {
        publicacion.likes = reaccionesData['likes'] as int;
      }
    }
  }
  // Mostrar datos en consola
  publicacionesList.forEach((publicacion) {
    if (kDebugMode) {
      //print("UID del usuario: ${publicacion.uid}");
      //print("ID del mapa: ${publicacion.pubID}");
      //print("Likes: ${publicacion.likes}");
    }
  }); // Llama a la función con los datos
  return publicacionesList; // Llama a la función con los datos
}
