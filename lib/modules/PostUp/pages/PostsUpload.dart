// ignore_for_file: non_constant_identifier_names

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

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
            }, child: Text("Seleccionar imagen")),
          ElevatedButton(
            onPressed: (){}, child: Text("Subir imagen"))
        ]
        ),  
      
      );
  }
}
