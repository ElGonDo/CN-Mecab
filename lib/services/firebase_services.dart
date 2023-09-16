import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getPubliR() async{
  List publiR = [];
  
  QuerySnapshot   querySnapshot = await db.collection('Publicaciones_Reseñables').get();
  
  for (var doc in querySnapshot.docs){
    publiR.add(doc.data());
  }
  return publiR;
}

Future<void> addTitle(String titulo, String descripcion, String selectedCategory, String? selectedGenero) async{
  await db.collection("Publicaciones_Reseñables").add({
    "Titulo" : titulo, 
    "Descripcion" : descripcion,
    "Categoria" : selectedCategory,
    "Genero" : selectedGenero,
    });
}