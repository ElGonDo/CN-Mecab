// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnmecab/modules/Post_show/show_post_Resenables.dart';
import 'package:flutter/material.dart';

void guardarPublicacion(BuildContext context, String uidCreador,
    String idPublicacion, String uidUsuarioActual) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  firestore
      .collection('Publicaciones_Guardadas')
      .doc(uidUsuarioActual)
      .get()
      .then((doc) {
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.containsKey(uidCreador)) {
        if (!data[uidCreador].contains(idPublicacion)) {
          data[uidCreador].add(idPublicacion);
          firestore
              .collection('Publicaciones_Guardadas')
              .doc(uidUsuarioActual)
              .set(data);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('¡Publicación Guardada En El Perfil!'),
            duration: Duration(seconds: 2),
          ));
        }
      } else {
        data[uidCreador] = [idPublicacion];
        firestore
            .collection('Publicaciones_Guardadas')
            .doc(uidUsuarioActual)
            .set(data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('¡Publicación Guardada En El Perfil!'),
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      Map<String, dynamic> newData = {
        uidCreador: [idPublicacion]
      };
      firestore
          .collection('Publicaciones_Guardadas')
          .doc(uidUsuarioActual)
          .set(newData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('¡Publicación Guardada En El Perfil!'),
        duration: Duration(seconds: 2),
      ));
    }
  });
}

Future<List<PublicacionR>> obtenerPublicacionesGuardadas(
    String uidUsuarioActual, List<PublicacionR> publicacionesR) async {
  List<PublicacionR> newPublicacionesGuardadasR = [];

  DocumentSnapshot document = await FirebaseFirestore.instance
      .collection("Publicaciones_Guardadas")
      .doc(uidUsuarioActual)
      .get();
  if (document.exists) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    data.forEach((uidCreador, idsPublicaciones) {
      List<String> ids = List<String>.from(idsPublicaciones);
      for (var idPublicacion in ids) {
        for (PublicacionR publicacionR in publicacionesR) {
          if (publicacionR.ruid == uidCreador &&
              publicacionR.rpubID == idPublicacion) {
            newPublicacionesGuardadasR.add(publicacionR);
          }
        }
      }
    });
  }
  return newPublicacionesGuardadasR;
}
