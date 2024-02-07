// ignore_for_file: file_names, must_be_immutable, avoid_print, non_constant_identifier_names
import 'dart:io';
import 'package:cnmecab/modules/PostUp/pages/select_Image.dart';
import 'package:cnmecab/modules/profile/pages/objetoUsuario.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PublicarCreators extends StatefulWidget {
  const PublicarCreators({super.key});

  @override
  State<PublicarCreators> createState() => CreatorsPage();
}

class CreatorsPage extends State<PublicarCreators> {
  UserProfile? userProfile;
  File? image_to_upload;

  @override
  void initState() {
    super.initState();
    // Obtener el perfil del usuario desde el Singleton
    userProfile = UserProfileSingleton().userProfile;

    if (userProfile != null) {
      // Verificar si el perfil del usuario está disponible y mostrar información
      print('Imagen UID: ${userProfile?.uid}');
      print('Imagen Rol: ${userProfile?.role}');
      print('Imagen name: ${userProfile?.name}');
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String fileName =
        '${userProfile!.uid}.jpg'; // Cambiar el nombre de la imagen por la UID del usuario
    try {
      final Reference ref = storage
          .ref()
          .child(userProfile?.role == 'Creador' ? "profileC" : "profileP")
          .child(fileName);
      final UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() => true);
    } catch (e) {
      print('Error al subir la imagen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Creadores y Promotoras'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 80,
              backgroundImage:
                  image_to_upload != null ? FileImage(image_to_upload!) : null,
              backgroundColor: Colors.grey, // Color de fondo del círculo
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final XFile? image =
                    await getImage(); // Asegúrate de que la función getImage esté definida
                if (image != null) {
                  setState(() {
                    image_to_upload = File(image.path);
                  });
                  uploadProfileImage(image_to_upload!);
                }
              },
              child: const Text('Subir Foto De Perfil'),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('¡Foto de perfil actualizada!'),
                  duration: Duration(seconds: 2),
                ));
              },
              child: const Text('Guardar Foto De Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
