// ignore_for_file: avoid_print, file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserCredential?> register(String email, String password,
      BuildContext context, String selectedRole) async {
    try {
      // Mostrar alerta de espera
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Espere un minuto mientras te registramos..."),
              ],
            ),
          );
        },
      );

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar en la base de datos después del registro en Authentication
      final user = userCredential.user;
      await _firestore.collection('Usuarios').doc(user!.uid).set({
        'Rol': selectedRole,
        'Fecha_Registro': DateTime.now(),
      });

      // Cerrar la alerta de espera
      Navigator.of(context).pop();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // Manejar contraseña débil
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('La contraseña proporcionada es muy débil.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      } else if (e.code == 'email-already-in-use') {
        // Manejar correo electrónico ya en uso
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'La cuenta ya existe para ese correo electrónico.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      } else if (e.code == 'operation-not-allowed') {
        // Manejar operación no permitida (por ejemplo, la autenticación por correo y contraseña no está habilitada)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'El registro mediante correo electrónico y contraseña no está habilitado.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      } else {
        // Manejar otros errores desconocidos
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
                  Text('Ocurrió un error durante el registro: ${e.message}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Manejar cualquier otro tipo de error no relacionado con FirebaseAuthException
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Ocurrió un error inesperado: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
    return null;
  }

  Future<UserCredential?> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Manejar errores específicos de FirebaseAuth
      if (e.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error Al Iniciar Sesion'),
              content:
                  const Text('Correo Electrónico No Se Encuentra Registrado'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: const Text('¡Regístrate Aquí!'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      } else if (e.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error Al Iniciar Sesion'),
              content: const Text(
                  'La Contraseña Es Incorrecta, Por Favor Inténtalo De Nuevo'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      } else if (e.code == 'user-disabled') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error Al Iniciar Sesion'),
              content:
                  const Text('Esta Cuenta de Usuario Ha Sido Deshabilitada'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      } else if (e.code == 'too-many-requests') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error Al Iniciar Sesion'),
              content: const Text(
                  'Demasiados Intentos Fallidos. Intente Nuevamente Más Tarde.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Manejar cualquier otro tipo de error no relacionado con FirebaseAuthException
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Ocurrió un error inesperado: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
    return null;
  }
}
