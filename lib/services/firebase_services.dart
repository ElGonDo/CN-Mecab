import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getPubliR() async {
  List publiR = [];

  QuerySnapshot querySnapshot =
      await db.collection('Publicaciones_Reseñables').get();

  for (var doc in querySnapshot.docs) {
    publiR.add(doc.data());
  }
  return publiR;
}

Future<void> addTitle(
  String titulo,
  String descripcion,
  String selectedCategory,
  String? selectedGenero,
  String? collectionName,
) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Utiliza el UID del usuario como nombre de documento
    final documentReference = db.collection(collectionName!).doc(user.uid);
    final postId = DateTime.now().millisecondsSinceEpoch.toString();
    final postData = {
      "Titulo": titulo,
      "Descripcion": descripcion,
      "Categoria": selectedCategory,
      "Genero": selectedGenero,
    };
    await documentReference.set(
      {postId: postData},
      SetOptions(merge: true),
    );
  }
}
