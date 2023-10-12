// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cnmecab/modules/profile/pages/profile.dart';

List<String> imageNames = [
  'Firefly perfil de avatar 29892.jpg',
  'Firefly perfil de avatar 35512.jpg',
  'Firefly perfil de avatar 51841.jpg',
  'Firefly perfiles de avatar 20770.jpg',
  'Firefly perfiles de avatar 53116.jpg',
  'Firefly perfiles de avatar 53859.jpg',
  'Firefly perfiles de avatar 62552.jpg',
  'Firefly perfiles de avatar 67575.jpg',
  'Firefly perfiles de avatar 76738.jpg',
  'Firefly perfiles de avatar 91583.jpg',
];

Future<Widget> _getImageWidget(String imageName) async {
  try {
    final ref = FirebaseStorage.instance.ref().child('profileV/$imageName');
    final url = await ref.getDownloadURL();
    return Image.network(url);
  } catch (e) {
    print('Error al obtener la imagen: $e');
    return const Text('Error al cargar la imagen');
  }
}

class ImageListScreen extends StatefulWidget {
  const ImageListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  String? selectedImage;
  UserProfile? userProfile;
  @override
  void initState() {
    super.initState();
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
