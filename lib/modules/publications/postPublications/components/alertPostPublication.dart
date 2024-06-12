// alertPostPublication.dart

// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, non_constant_identifier_names, file_names

import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> alertPostPublication(
  BuildContext context,
  TextEditingController tituloController,
  TextEditingController descripcionController,
  TextEditingController directorController,
  TextEditingController productorController,
  TextEditingController guionistaController,
  TextEditingController distriController,
  TextEditingController companiaController,
  TextEditingController clasificacionController,
  TextEditingController idiomaController,
  TextEditingController fechaEstrenoController,
  TextEditingController duracionController,
  String? _selectedCategory,
  List<String> _selectedGeneros,
  String? collectionName,
  File? imageToUpload,
  String? _tipoPubli,
  Function enviarANotificaciones,
  Function Publicaciones_Resenables,
  Function Publicaciones_No_Resenables,
  Function uploadImage,
  Function _showAlert,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmación de Publicación'),
        content: RichText(
          text: TextSpan(
            text:
                '¿Estás seguro de que deseas subir esta publicación? Recuerda que tu publicación será eliminada si incumple las ',
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'normas de la comunidad',
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pop(); // Cierra el diálogo actual
                    // Navegar a la sección de normas de la comunidad
                    Navigator.of(context).pushNamed('/comunityNorms');
                  },
              ),
              TextSpan(
                text: '.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context)
                  .pop(); // Cierra el diálogo antes de continuar

              String postId;
              if (_tipoPubli == 'Reseñable') {
                postId = await Publicaciones_Resenables(
                  tituloController.text,
                  descripcionController.text,
                  directorController.text,
                  productorController.text,
                  guionistaController.text,
                  distriController.text,
                  companiaController.text,
                  clasificacionController.text,
                  idiomaController.text,
                  fechaEstrenoController.text,
                  duracionController.text,
                  _selectedCategory ?? '',
                  _selectedGeneros,
                  collectionName ?? '',
                );
              } else {
                postId = await Publicaciones_No_Resenables(
                  tituloController.text,
                  descripcionController.text,
                  _selectedCategory ?? '',
                  _selectedGeneros,
                );
              }

              final uploaded = await uploadImage(imageToUpload!, postId);

              if (!uploaded) {
                _showAlert("Éxito", "Imagen subida correctamente.");
                return;
              } else {
                _showAlert("Error", "Error al subir la imagen.");
              }

              await enviarANotificaciones(
                tituloController.text,
                descripcionController.text,
                _selectedCategory ?? '',
                FirebaseAuth.instance.currentUser?.uid ?? '',
              );
            },
            child: Text('Continuar'),
          ),
        ],
      );
    },
  );
}
