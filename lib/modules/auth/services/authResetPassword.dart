// ignore_for_file: file_names, use_build_context_synchronously
// Función resetPassword
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> resetPassword(BuildContext context, FirebaseAuth auth) async {
  String email = '';
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Recuperar contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
                'Digite El Correo Electronico De Su Cuenta, Para Restablecer La Contraseña'),
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(hintText: 'Correo electrónico'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Recuperar'),
            onPressed: () async {
              bool success = await auth
                  .sendPasswordResetEmail(email: email)
                  .then((value) => true)
                  .catchError((onError) => false);
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(success
                        ? 'Contraseña Restablecida'
                        : 'Error Al Restablecer La Contraseña'),
                    content: Text(success
                        ? 'El restablecimiento fue exitoso, revise su correo de su cuenta para restablecer la contraseña'
                        : 'No se pudo restablecer la contraseña, por favor inténtelo de nuevo'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      );
    },
  );
}
