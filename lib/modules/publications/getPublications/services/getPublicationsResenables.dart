// ignore_for_file: file_names, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PublicacionR {
  final String rcategoria;
  final String rdescripcion;
  final List<String> rgenero;
  final String rtitulo;
  final String ruid; // La UID del usuario
  final String rpubID; // La ID de cada mapa dentro del documento
  double promedioResenas;
  final String clasificacion;
  final String compania;
  final String director;
  final String distribuidor;
  final String duracion;
  final String fechaEstreno;
  final String guionista;
  final String idioma;
  final String productor;

  PublicacionR({
    required this.rcategoria,
    required this.rdescripcion,
    required this.rgenero,
    required this.rtitulo,
    required this.ruid,
    required this.rpubID,
    required this.promedioResenas,
    required this.clasificacion,
    required this.compania,
    required this.director,
    required this.distribuidor,
    required this.duracion,
    required this.fechaEstreno,
    required this.guionista,
    required this.idioma,
    required this.productor,
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
      List<String> rgenero = List<String>.from(publicacionR['generos']);
      String rtitulo = publicacionR['Titulo'];
      String clasificacion = publicacionR['Clasificacion'];
      String compania = publicacionR['Compania'];
      String director = publicacionR['Director'];
      String distribuidor = publicacionR['Distribuidor'];
      String duracion = publicacionR['Duracion'];
      String fechaEstreno = publicacionR['FechaEstreno'];
      String guionista = publicacionR['Guionista'];
      String idioma = publicacionR['Idioma'];
      String productor = publicacionR['Productor'];

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
        clasificacion: clasificacion,
        compania: compania,
        director: director,
        distribuidor: distribuidor,
        duracion: duracion,
        fechaEstreno: fechaEstreno,
        guionista: guionista,
        idioma: idioma,
        productor: productor,
      );
      publicacionesListR.add(nuevaPublicacionR);

      // Imprime el promedio de reseñas para cada publicación
      if (kDebugMode) {
        /*print(
            "Promedio de reseñas para ${nuevaPublicacionR.rpubID}: $promedioResenas");*/
      }
    });
  }

  // Muestra en la consola cada UID del usuario y la ID de cada mapa
  for (var publicacion in publicacionesListR) {
    if (kDebugMode) {
      //print("UID del usuario: ${publicacion.ruid}");
    }
    if (kDebugMode) {
      //print("ID del mapa: ${publicacion.rpubID}");
    }
  }

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
