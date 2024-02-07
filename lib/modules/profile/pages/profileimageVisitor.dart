// ignore_for_file: avoid_print, library_private_types_in_public_api, use_build_context_synchronously, file_names
import 'package:cnmecab/modules/profile/pages/objetoUsuario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> imageNames = [
  'Firefly perfil de avatar 29892',
  'Firefly perfil de avatar 35512',
  'Firefly perfil de avatar 51841',
  'Firefly perfiles de avatar 20770',
  'Firefly perfiles de avatar 53116',
  'Firefly perfiles de avatar 53859',
  'Firefly perfiles de avatar 62552',
  'Firefly perfiles de avatar 67575',
  'Firefly perfiles de avatar 76738',
  'Firefly perfiles de avatar 91583',
];

Future<Widget> _getImageWidget(String imageName) async {
  try {
    final ref = FirebaseStorage.instance.ref().child('profileV/$imageName.jpg');
    final url = await ref.getDownloadURL();
    return Image.network(url);
  } catch (e) {
    print('Error al obtener la imagen: $e');
    return const Text('Error al cargar la imagen');
  }
}

Future<void> updateVisitorProfileImage(
    String currentUserUid, String selectedImage) async {
  try {
    // Actualizar los datos del visitante en la colección "Visitantes"
    await FirebaseFirestore.instance
        .collection('Visitantes')
        .doc(currentUserUid)
        .update({
      'ImagenPerfil': selectedImage,
    });
  } catch (e) {
    print('Error al actualizar la imagen del perfil del visitante: $e');
    // Manejar el error según sea necesario
  }
}

class ImageListScreen extends StatefulWidget {
  const ImageListScreen({Key? key}) : super(key: key);

  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  String? selectedImage;
  UserProfile? userProfile;

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

  Future<void> _updateProfileImage() async {
    if (userProfile != null && selectedImage != null) {
      await updateVisitorProfileImage(userProfile!.uid, selectedImage!);
      print('Imagen de perfil actualizada: $selectedImage');

      // Mostrar la notificación de foto de perfil actualizada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Foto de perfil actualizada!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto De Perfil'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 50,
            child: selectedImage != null
                ? FutureBuilder<Widget>(
                    future: _getImageWidget(selectedImage!),
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error al cargar la imagen');
                      } else {
                        return ClipOval(
                          child: snapshot.data ?? Container(),
                        );
                      }
                    },
                  )
                : const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 50,
                  ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: imageNames.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImage = imageNames[index];
                    });
                    _updateProfileImage(); // Llama al método para actualizar la imagen de perfil
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: FutureBuilder<Widget>(
                      future: _getImageWidget(imageNames[index]),
                      builder: (BuildContext context,
                          AsyncSnapshot<Widget> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error al cargar la imagen');
                        } else {
                          return snapshot.data ?? Container();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
