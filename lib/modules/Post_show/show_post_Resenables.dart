// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PublicacionR {
  final String rcategoria;
  final String rdescripcion;
  final String rgenero;
  final String rtitulo;
  final String ruid; // La UID del usuario
  final String rpubID; // La ID de cada mapa dentro del documento

  PublicacionR({
    required this.rcategoria,
    required this.rdescripcion,
    required this.rgenero,
    required this.rtitulo,
    required this.ruid,
    required this.rpubID,
  });
}

void obtenerDatosR(Function(List<PublicacionR>) onDataFetched) async {
  final firestoreInstance = FirebaseFirestore.instance;
  List<PublicacionR> publicacionesListR = [];

  QuerySnapshot querySnapshot =
      await firestoreInstance.collection('Publicaciones_Reseñables').get();

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    String uid = doc.id; // Obtener la UID del usuario
    Map<String, dynamic> publicacionesR = doc.data() as Map<String, dynamic>;

    publicacionesR.forEach((pubID, value) {
      Map<String, dynamic> publicacionR = value as Map<String, dynamic>;

      String rcategoria = publicacionR['Categoria'];
      String rdescripcion = publicacionR['Descripcion'];
      String rgenero = publicacionR['Genero'];
      String rtitulo = publicacionR['Titulo'];

      // Crear una instancia de Publicacion y agregarla a la lista
      PublicacionR nuevaPublicacionR = PublicacionR(
        rcategoria: rcategoria,
        rdescripcion: rdescripcion,
        rgenero: rgenero,
        rtitulo: rtitulo,
        ruid: uid, // Asignar la UID del usuario
        rpubID: pubID, // Asignar la ID de cada mapa
      );
      publicacionesListR.add(nuevaPublicacionR);
    });
  }

  onDataFetched(publicacionesListR); // Llama a la función con los datos
  publicacionesListR.forEach((publicacion) {
    // Muestra en la consola cada UID del usuario y la ID de cada mapa
    if (kDebugMode) {
      //print("UID del usuario: ${publicacion.ruid}");
    }
    if (kDebugMode) {
      //print("ID del mapa: ${publicacion.rpubID}");
    }
  });
}
