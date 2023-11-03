// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Publicacion {
  final String categoria;
  final String descripcion;
  final String genero;
  final String titulo;

  Publicacion({
    required this.categoria,
    required this.descripcion,
    required this.genero,
    required this.titulo,
  });
}

void obtenerDatos(Function(List<Publicacion>) onDataFetched) async {
  final firestoreInstance = FirebaseFirestore.instance;
  List<Publicacion> publicacionesList = [];

  QuerySnapshot querySnapshot =
      await firestoreInstance.collection('Publicaciones_No_Reseñables').get();

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    Map<String, dynamic> publicaciones = doc.data() as Map<String, dynamic>;

    publicaciones.forEach((key, value) {
      Map<String, dynamic> publicacion = value as Map<String, dynamic>;

      String categoria = publicacion['Categoria'];
      String descripcion = publicacion['Descripcion'];
      String genero = publicacion['Genero'];
      String titulo = publicacion['Titulo'];

      // Crear una instancia de Publicacion y agregarla a la lista
      Publicacion nuevaPublicacion = Publicacion(
        categoria: categoria,
        descripcion: descripcion,
        genero: genero,
        titulo: titulo,
      );
      publicacionesList.add(nuevaPublicacion);
    });

    onDataFetched(publicacionesList); // Llama a la función con los datos
  }
}
