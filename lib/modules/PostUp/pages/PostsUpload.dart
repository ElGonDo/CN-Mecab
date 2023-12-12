// ignore_for_file: file_names

import 'dart:io';
import 'package:cnmecab/modules/PostUp/pages/select_Image.dart';
import 'package:cnmecab/modules/PostUp/pages/upload_image.dart';
import 'package:cnmecab/services/firebase_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Publicar extends StatefulWidget {
  const Publicar({super.key});

  @override
  State<Publicar> createState() => _PublicarState();
}

class _PublicarState extends State<Publicar> {
  TextEditingController tituloController = TextEditingController(text: "");
  TextEditingController descripcionController = TextEditingController(text: "");
  // ignore: non_constant_identifier_names
  File? image_to_upload;
  String? _selectedGenero = '';
  String _selectedCategory = '';
  String? _tipoPubli;
  List<String> categoriasSeleccionadas = [];
  String? collectionName;

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onTypePubli(String tipoPubli) {
    setState(() {
      _tipoPubli = tipoPubli;
    });
    if (tipoPubli == 'Reseñable') {
      collectionName = "Publicaciones_Reseñables";
    } else if (tipoPubli == 'No reseñable') {
      collectionName = "Publicaciones_No_Reseñables";
    } else {
      // Puedes manejar un caso predeterminado aquí si es necesario
      return;
    }
  }

  void _onGeneroSelected(String genero) {
    setState(() {
      _selectedGenero = genero;
    });
  }
  
  @override
  void initState(){
    super.initState();
    initializeUserId();
  }
  Future<void> initializeUserId() async{
    try{
       User? user = FirebaseAuth.instance.currentUser;

if (user != null) {
  String uid = user.uid;
  if (kDebugMode) {
    print('El UID del usuario es: $uid');
  }
} else {
  if (kDebugMode) {
    print('No hay usuario autenticado.');
  }
}
    }catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Tipo de publicación:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  label: const Text('Reseñable'),
                  selected: _tipoPubli == 'Reseñable',
                  onSelected: (selected) {
                    _onTypePubli('Reseñable');
                  },
                ),
                ChoiceChip(
                  label: const Text('No reseñable'),
                  selected: _tipoPubli == 'No reseñable',
                  onSelected: (selected) {
                    _onTypePubli('No reseñable');
                  },
                ),
              ],
            ),
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: 'Titulo de la publicación',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción de la publicación',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Categoría de tu publicación',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: const Text('Películas'),
              leading: Radio(
                value: 'Películas',
                groupValue: _selectedCategory,
                onChanged: (value) {
                  _onCategorySelected('Películas');
                },
              ),
            ),
            ListTile(
              title: const Text('Series'),
              leading: Radio(
                value: 'Series',
                groupValue: _selectedCategory,
                onChanged: (value) {
                  _onCategorySelected('Series');
                },
              ),
            ),
            ListTile(
              title: const Text('Libros'),
              leading: Radio(
                value: 'Libros',
                groupValue: _selectedCategory,
                onChanged: (value) {
                  _onCategorySelected('Libros');
                },
              ),
            ),
            ListTile(
              title: const Text('Animes'),
              leading: Radio(
                value: 'Animes',
                groupValue: _selectedCategory,
                onChanged: (value) {
                  _onCategorySelected('Animes');
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Género:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  label: const Text('Acción'),
                  selected: _selectedGenero == 'Acción',
                  onSelected: (selected) {
                    _onGeneroSelected('Acción');
                  },
                ),
                ChoiceChip(
                  label: const Text('Comedia'),
                  selected: _selectedGenero == 'Comedia',
                  onSelected: (selected) {
                    _onGeneroSelected('Comedia');
                  },
                ),
                ChoiceChip(
                  label: const Text('Drama'),
                  selected: _selectedGenero == 'Drama',
                  onSelected: (selected) {
                    _onGeneroSelected('Drama');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            image_to_upload != null
                ? Image.file(image_to_upload!)
                : Container(
                    margin: const EdgeInsets.all(10),
                    height: 200,
                    width: double.infinity,
                    color: Colors.red,
                  ),
            ElevatedButton(
                onPressed: () async {
                  final XFile? imagen = await getImage();
                  setState(() {
                    image_to_upload = File(imagen!.path);
                  });
                },
                child: const Text("Seleccionar imagen")),
            ElevatedButton(
                onPressed: () async {
                  await addTitle(
                      tituloController.text,
                      descripcionController.text,
                      _selectedCategory,
                      _selectedGenero,
                      collectionName);
                  if (image_to_upload == null) {
                    return;
                  }
                  final uploaded = await uploadImage(image_to_upload!);

                  if (uploaded) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Error al subir la imagen")));
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("imagen subida correctamente")));
                  }
                },
                child: const Text("Subir Publicacion"))
          ],
        ),
      ),
    );
  }
}
