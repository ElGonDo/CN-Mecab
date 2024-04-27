// ignore_for_file: file_names, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

Future<bool> solicitarAutenticacion(BuildContext context) async {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var result = await showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: const Text('Ingrese sus credenciales'),
      content: Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
            controller: passwordController,
          ),
        ],
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: const Text('Aceptar'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        BasicDialogAction(
          title: const Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    ),
  );

  if (result == true) {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (error) {
      print('Error de autenticación: $error');
      return false;
    }
  } else {
    return false;
  }
}
