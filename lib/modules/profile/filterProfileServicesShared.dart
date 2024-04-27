// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsResenables.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsNoResenables.dart';
import 'package:flutter/material.dart';

void compartirPublicacion(BuildContext context, String uidCreador,
    String idPublicacion, String uidUsuarioActual) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  firestore
      .collection('Publicaciones_Compartidas')
      .doc(uidUsuarioActual)
      .get()
      .then((doc) {
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.containsKey(uidCreador)) {
        if (!data[uidCreador].contains(idPublicacion)) {
          data[uidCreador].add(idPublicacion);
          firestore
              .collection('Publicaciones_Compartidas')
              .doc(uidUsuarioActual)
              .set(data);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('¡Publicación Compartida En El Perfil!'),
            duration: Duration(seconds: 2),
          ));
        }
      } else {
        data[uidCreador] = [idPublicacion];
        firestore
            .collection('Publicaciones_Compartidas')
            .doc(uidUsuarioActual)
            .set(data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('¡Publicación Compartida En El Perfil!'),
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      Map<String, dynamic> newData = {
        uidCreador: [idPublicacion]
      };
      firestore
          .collection('Publicaciones_Compartidas')
          .doc(uidUsuarioActual)
          .set(newData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('¡Publicación Compartida En El Perfil!'),
        duration: Duration(seconds: 2),
      ));
    }
  });
}

Future<Map<String, List<dynamic>>> obtenerPublicacionesCompartidas(
    String uidUsuarioActual,
    List<Publicacion> publicacionesNR,
    List<PublicacionR> publicacionesR) async {
  List<Publicacion> newPublicacionesNR = [];
  List<PublicacionR> newPublicacionesR = [];

  // Buscar en la colección "Publicaciones_Compartidas" el documento del usuario actual
  DocumentSnapshot document = await FirebaseFirestore.instance
      .collection("Publicaciones_Compartidas")
      .doc(uidUsuarioActual)
      .get();
  if (document.exists) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    data.forEach((uidCreador, idsPublicaciones) {
      List<String> ids = List<String>.from(idsPublicaciones);
      ids.forEach((idPublicacion) {
        // Buscar coincidencias en las listas publicacionesNR y publicacionesR
        for (Publicacion publicacion in publicacionesNR) {
          if (publicacion.uid == uidCreador &&
              publicacion.pubID == idPublicacion) {
            newPublicacionesNR.add(publicacion);
          }
        }

        for (PublicacionR publicacionR in publicacionesR) {
          if (publicacionR.ruid == uidCreador &&
              publicacionR.rpubID == idPublicacion) {
            newPublicacionesR.add(publicacionR);
          }
        }
      });
    });
  }
  // Retornar las nuevas listas en un Map
  return {
    "publicacionesNR": newPublicacionesNR,
    "publicacionesR": newPublicacionesR
  };
}
