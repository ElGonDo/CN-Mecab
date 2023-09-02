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
  String? _selectCategoria;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          DropdownButton<String>(
            value: _selectCategoria,
            onChanged: (String? newValue) {
              setState(() {
                _selectCategoria = newValue;
              });
            },
            items: <String>['Visitante', 'Creador', 'Promotora']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: const Text('Selecciona Un Rol'),
          ),
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
                      content: Text("imagen subida correctamente")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Error al subir la imagen")));
                }
              },
              child: const Text("Subir imagen"))
        ]),
      ),
    );
  }
}
