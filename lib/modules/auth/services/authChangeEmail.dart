// ignore_for_file: file_names, use_build_context_synchronously, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> cambiarCorreo(BuildContext context) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final user = auth.currentUser!;
  String currentEmail =
      user.email ?? ''; // Obtener el correo actual del usuario
  try {
    // Mostrar el diálogo emergente para ingresar el correo y contraseña
    var result = await showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: const Text('Cambiar de correo: '),
        content: Column(
          children: [
            Text('Correo actual: $currentEmail'), // Mostrar el correo actual
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Nuevo correo electrónico'),
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
            ),
          ],
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: const Text('Aceptar'),
            onPressed: () {
              // Cerrar el diálogo emergente y continuar con el cambio de correo
              Navigator.pop(context, true);
            },
          ),
          BasicDialogAction(
            title: const Text('Cancelar'),
            onPressed: () {
              // Cerrar el diálogo emergente sin realizar el cambio de correo
              Navigator.pop(context, false);
            },
          ),
        ],
      ),
    );

    // Verificar si el usuario aceptó el diálogo emergente
    if (result == true) {
      // Obtener los datos ingresados por el usuario
      String newEmail = emailController.text;
      try {
        await user.verifyBeforeUpdateEmail(newEmail);
        Fluttertoast.showToast(msg: 'Correo actualizado exitosamente');
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacementNamed(
            '/welcome'); // Cerrar sesión automáticamente después de cambiar el correo
        return true;
      } catch (error) {
        //print('Error al actualizar el correo electrónico: $error');
        Fluttertoast.showToast(
            msg: 'Error al actualizar el correo electrónico');
      }
      // El Cambio de correo fue exitoso
      return true;
    } else {
      // El usuario canceló el diálogo emergente
      return false;
    }
  } catch (error) {
    // Ocurrió un error durante el cambio de correo
    //print('Error de autenticación: $error');
    // Puedes mostrar un mensaje de error al usuario o realizar alguna otra acción

    return false;
  }
}
