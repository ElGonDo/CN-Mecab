// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
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
