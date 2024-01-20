// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<bool> uploadImage(File image, String pubId) async {
 try {
    // Utiliza la ID de la publicación como nombre del archivo
    final String namefile = '$pubId.jpg';
    
    final Reference ref = storage.ref().child("post").child(namefile);
    final UploadTask uploadTask = ref.putFile(image);
    
    await uploadTask.whenComplete(() => true);

    return false; // Indica que la operación fue exitosa
  } catch (e) {
    // Maneja cualquier error que pueda ocurrir durante la carga
    if (kDebugMode) {
      print('Error al subir la imagen: $e');
    }
    return true; // Indica que hubo un error
  }
}
