// ignore_for_file: non_constant_identifier_names, file_names, use_build_context_synchronously

import 'dart:io';

import 'package:cnmecab/modules/PostUp/pages/select_Image.dart';
import 'package:cnmecab/modules/PostUp/pages/upload_image.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Publicar extends StatefulWidget {
  const Publicar({
    super.key,
  });

  @override
  State<Publicar> createState() => _PublicarState();
}

class _PublicarState extends State<Publicar> {
  File? image_to_upload;
  String? _selectedGenero;
  String? _selectedCategory;
  String? _tipoPubli;
  List<String> categoriasSeleccionadas = [];
void _onCategorySelected(String category) {
    setState(() {
      _selectedGenero = category;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column( children: [
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
                    _onCategorySelected('Reseñable');
                  },
                ),
                ChoiceChip(
                  label: const Text('No reseñable'),
                  selected: _tipoPubli == 'No reseñable',
                  onSelected: (selected) {
                    _onCategorySelected('No reseñable');
                  },
                ),
              ],
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Titulo de la publicación',
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
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
              title: const Text('Animación'),
              leading: Radio(
                value: 'Animación',
                groupValue: _selectedCategory,
                onChanged: (value) {
                  _onCategorySelected('Animación');
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
                    _onCategorySelected('Acción');
                  },
                ),
                ChoiceChip(
                  label: const Text('Comedia'),
                  selected: _selectedGenero == 'Comedia',
                  onSelected: (selected) {
                    _onCategorySelected('Comedia');
                  },
                ),
                ChoiceChip(
                  label: const Text('Drama'),
                  selected: _selectedGenero == 'Drama',
                  onSelected: (selected) {
                    _onCategorySelected('Drama');
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
                if (image_to_upload == null) {
                  return;
                }
                final uploaded = await uploadImage(image_to_upload!);

                if (uploaded) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Error al subir la imagen")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("imagen subida correctamente")));
                }
              },
              child: const Text("Subir imagen"))
        ]),
      ),
    );
  }
}
