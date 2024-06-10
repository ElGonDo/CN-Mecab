// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnmecab/modules/home/components/buildersCards.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsResenables.dart';
import 'package:flutter/material.dart';

Future<List<PublicacionR>> obtenerPublicacionesPorEstrellas(
    int estrellas) async {
  final firestoreInstance = FirebaseFirestore.instance;
  List<PublicacionR> publicacionesFiltradas = [];

  double min = 0.0, max = 0.0;

  switch (estrellas) {
    case 1:
      min = 0.0;
      max = 1.9;
      break;
    case 2:
      min = 2.0;
      max = 2.9;
      break;
    case 3:
      min = 3.0;
      max = 3.9;
      break;
    case 4:
      min = 4.0;
      max = 4.5;
      break;
    case 5:
      min = 4.5;
      max = 5.0;
      break;
  }

  QuerySnapshot querySnapshot =
      await firestoreInstance.collection('Publicaciones_Reseñables').get();

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    String uid = doc.id;
    Map<String, dynamic> publicacionesR = doc.data() as Map<String, dynamic>;

    for (String pubID in publicacionesR.keys) {
      Map<String, dynamic> publicacionR =
          publicacionesR[pubID] as Map<String, dynamic>;

      double promedioResenas = await obtenerPromedioResenas(pubID);

      if (promedioResenas >= min && promedioResenas <= max) {
        PublicacionR nuevaPublicacionR = PublicacionR(
          rcategoria: publicacionR['Categoria'],
          rdescripcion: publicacionR['Descripcion'],
          rgenero: List<String>.from(publicacionR['generos']),
          rtitulo: publicacionR['Titulo'],
          ruid: uid,
          rpubID: pubID,
          promedioResenas: promedioResenas,
          clasificacion: publicacionR['Clasificacion'],
          compania: publicacionR['Compania'],
          director: publicacionR['Director'],
          distribuidor: publicacionR['Distribuidor'],
          duracion: publicacionR['Duracion'],
          fechaEstreno: publicacionR['FechaEstreno'],
          guionista: publicacionR['Guionista'],
          idioma: publicacionR['Idioma'],
          productor: publicacionR['Productor'],
        );
        publicacionesFiltradas.add(nuevaPublicacionR);
      }
    }
  }
  return publicacionesFiltradas;
}

void showFilteredResultsModal(
    BuildContext context,
    List<PublicacionR> publicacionesFiltradas,
    String uidUsuarioActual,
    TextEditingController comentarioController,
    String urlString) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Resultados del Filtro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: publicacionesFiltradas.length,
                itemBuilder: (context, index) {
                  PublicacionR pub = publicacionesFiltradas[index];
                  return buildCardWidget2(
                    pub.rtitulo,
                    pub.rdescripcion,
                    pub.rpubID,
                    '${pub.rpubID}.jpg', // Aquí debes pasar el nombre de la imagen correspondiente
                    pub.ruid,
                    context,
                    uidUsuarioActual,
                    comentarioController,
                    urlString,
                    pub,
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Regresar'),
            ),
          ],
        ),
      );
    },
  );
}
