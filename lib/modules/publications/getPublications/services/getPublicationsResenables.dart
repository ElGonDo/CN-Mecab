// ignore_for_file: avoid_function_literals_in_foreach_calls, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PublicacionR {
  final String rcategoria;
  final String rdescripcion;
  final String rgenero;
  final String rtitulo;
  final String ruid; // La UID del usuario
  final String rpubID; // La ID de cada mapa dentro del documento
  double promedioResenas;

  PublicacionR({
    required this.rcategoria,
    required this.rdescripcion,
    required this.rgenero,
    required this.rtitulo,
    required this.ruid,
    required this.rpubID,
    required this.promedioResenas,
  });
}

Future<List<PublicacionR>> obtenerDatosR() async {
  final firestoreInstance = FirebaseFirestore.instance;
  List<PublicacionR> publicacionesListR = [];

  QuerySnapshot querySnapshot =
      await firestoreInstance.collection('Publicaciones_Reseñables').get();

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    String uid = doc.id;
    Map<String, dynamic> publicacionesR = doc.data() as Map<String, dynamic>;

    publicacionesR.forEach((pubID, value) async {
      Map<String, dynamic> publicacionR = value as Map<String, dynamic>;

      String rcategoria = publicacionR['Categoria'];
      String rdescripcion = publicacionR['Descripcion'];
      String rgenero = publicacionR['Genero'];
      String rtitulo = publicacionR['Titulo'];

      // Obtiene el promedio de reseñas para cada publicación
      double promedioResenas = await obtenerPromedioResenas(pubID);

      PublicacionR nuevaPublicacionR = PublicacionR(
        rcategoria: rcategoria,
        rdescripcion: rdescripcion,
        rgenero: rgenero,
        rtitulo: rtitulo,
        ruid: uid,
        rpubID: pubID,
        promedioResenas: promedioResenas,
      );
      publicacionesListR.add(nuevaPublicacionR);

      // Imprime el promedio de reseñas para cada publicación
      if (kDebugMode) {
        print(
            "Promedio de reseñas para ${nuevaPublicacionR.rpubID}: $promedioResenas");
      }
    });
  }

  // Muestra en la consola cada UID del usuario y la ID de cada mapa
  publicacionesListR.forEach((publicacion) {
    if (kDebugMode) {
      print("UID del usuario: ${publicacion.ruid}");
    }
    if (kDebugMode) {
      print("ID del mapa: ${publicacion.rpubID}");
    }
  });

  return publicacionesListR;
}

Future<double> obtenerPromedioResenas(String pubID) async {
  final firestoreInstance = FirebaseFirestore.instance;

  // Obtiene el documento de reseñas
  DocumentSnapshot<Map<String, dynamic>> resenasDoc =
      await firestoreInstance.collection('Reseñas').doc(pubID).get();

  if (resenasDoc.exists) {
    // Accede al campo "promedio" dentro del documento de reseñas
    double? promedio = resenasDoc.data()?['promedio'];
    return promedio ?? 0.0;
  } else {
    return 0.0;
  }
}
