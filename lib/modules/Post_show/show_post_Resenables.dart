// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';


class PublicacionR {
  final String rcategoria;
  final String rdescripcion;
  final String rgenero;
  final String rtitulo;

  PublicacionR({
    required this.rcategoria,
    required this.rdescripcion,
    required this.rgenero,
    required this.rtitulo,
  });
}
void obtenerDatosR(Function(List<PublicacionR>) onDataFetched) async {
  final firestoreInstance = FirebaseFirestore.instance;
  List<PublicacionR> publicacionesListR = [];

  QuerySnapshot querySnapshot =
      await firestoreInstance.collection('Publicaciones_Reseñables').get();

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    Map<String, dynamic> publicacionesR = doc.data() as Map<String, dynamic>;

    publicacionesR.forEach((key, value) {
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
      );
      publicacionesListR.add(nuevaPublicacionR);
    });

    onDataFetched(publicacionesListR); // Llama a la función con los datos
  }
}