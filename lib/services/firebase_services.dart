import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

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
      "FechaHora": FieldValue.serverTimestamp(),
    };
    await documentReference.set(
      {postId: postData},
      SetOptions(merge: true),
    );
  }
}