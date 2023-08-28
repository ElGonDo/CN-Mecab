import 'dart:io';

import 'package:cnmecab/modules/PostUp/pages/select_Image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';
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
  String? _selectedCategory;
  String? _selectedGenero;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        
        children: [
           const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Titulo de la publicacion',
              ),         
        ),
          const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Sub Titulo de la publicacion',
              ),         
        ),
          const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Descripcion de la publicacion',
              ),         
        ),
        DropdownButton<String>(
              value: _selectedGenero,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGenero = newValue;
                });
              },
              items: <String>['Genero1', 'Genero2', 'Genero3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text('Selecciona Un Genero'),
            ),
          DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: <String>['Categoria1', 'Categoria2', 'Categoria3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text('Selecciona Una Categoria'),
            ),
         image_to_upload != null ?Image.file(image_to_upload!) : Container(
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
            }, child: const Text("Seleccionar imagen")),
          ElevatedButton(
            onPressed: (){}, child: const Text("Subir imagen")
            )
              

        ],
        
        
      ),
      );
  }
}
