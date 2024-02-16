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

  Publicacion({
    required this.categoria,
    required this.descripcion,
    required this.genero,
    required this.titulo,
    required this.uid,
    required this.pubID,
    required this.esResenable, 
  });
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
      );
      publicacionesList.add(nuevaPublicacion);
    });
  }
  onDataFetched(publicacionesList); // Llama a la función con los datos
  publicacionesList.forEach((publicacion) {
    // Muestra en la consola cada UID del usuario y la ID de cada mapa
    if (kDebugMode) {
      print("UID del usuario: ${publicacion.uid}");
    }
    if (kDebugMode) {
      print("ID del mapa: ${publicacion.pubID}");
    }
   });  // Llama a la función con los datos
}
