// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<bool> uploadImage(File image) async {
  final String namefile = image.path.split("/").last;
  final Reference ref = storage.ref().child("post").child(namefile);
  final UploadTask uploadTask = ref.putFile(image);
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  final String url = await snapshot.ref.getDownloadURL();
  return false;
}
