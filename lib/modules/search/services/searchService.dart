// ignore_for_file: file_names, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> searchUsersByName(String name) {
    return _firestore
        .collection('Usuarios')
        .where('Nombre', isGreaterThanOrEqualTo: name)
        .snapshots();
  }
}
