// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Publicacion {
  final String categoria;
  final String descripcion;
  final String genero;
  final String titulo;
  final String uid; // La UID del usuario
  final String pubID; // La ID de cada mapa dentro del documento
  final bool esResenable; 
  int likes;

  Publicacion({
    required this.categoria,
    required this.descripcion,
    required this.genero,
    required this.titulo,
    required this.uid,
    required this.pubID,
    required this.esResenable,
    required this.likes, 
  });

  get usuariosQueDieronLike => null;
}

void obtenerDatos(Function(List<Publicacion>) onDataFetched) async {
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
      String genero = publicacion['Genero'];
      String titulo = publicacion['Titulo'];
      bool esResenable = publicacion['Reseñable'] ?? false; 

      // Crear una instancia de Publicacion y agregarla a la lista
      Publicacion nuevaPublicacion = Publicacion(
        categoria: categoria,
        descripcion: descripcion,
        genero: genero,
        titulo: titulo,
        uid: uid, // Asignar la UID del usuario
        pubID: pubID,
        esResenable: esResenable, 
        likes: 0,
      );
      publicacionesList.add(nuevaPublicacion);
    });
  }
  for (Publicacion publicacion in publicacionesList) {
    DocumentSnapshot reaccionesDoc = await firestoreInstance.collection('Reacciones').doc(publicacion.pubID).get();
    if (reaccionesDoc.exists) {
      Map<String, dynamic> reaccionesData = reaccionesDoc.data() as Map<String, dynamic>;
      if (reaccionesData.containsKey('likes')) {
        publicacion.likes = reaccionesData['likes'] as int;
      }
    }
  }
   onDataFetched(publicacionesList); // Llama a la función con los datos

  // Mostrar datos en consola
  publicacionesList.forEach((publicacion) {
    if (kDebugMode) {
      print("UID del usuario: ${publicacion.uid}");
      print("ID del mapa: ${publicacion.pubID}");
      print("Likes: ${publicacion.likes}");
    }
   });  // Llama a la función con los datos
}
