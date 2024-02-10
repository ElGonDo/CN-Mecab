// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:cnmecab/modules/profile/pages/ObjetoUsuario2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cnmecab/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}*/

class LoginPage extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Iniciar Sesión',
            style: TextStyle(
              fontSize: 20, // Tamaño de fuente del título
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'CN',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' MECAB',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo Electrónico',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              // Nuevo código para la opción "Olvidaste la contraseña"
              TextButton(
                onPressed: () {
                  resetPassword(context); // Llamada a la función resetPassword
                },
                child: const Text(
                  '¿Olvidaste la contraseña?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  final String email = _emailController.text;
                  final String password = _passwordController.text;

                  AuthService _authService = AuthService();
                  UserCredential? userCredential =
                      await _authService.login(email, password);

                  if (userCredential != null) {
                    // Llamar al método para inicializar el objeto ProfileUser
                    final profileUser = ref.read(profileUserProvider
                        .notifier); // Usar .notifier para obtener el valor del provider
                    // Realiza las operaciones necesarias con el objeto ProfileUser
                    await initializeProfileUser(profileUser);
                    Navigator.of(context).pushNamed('/home');
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error al iniciar sesión'),
                          content: const Text(
                              'Ocurrió un error al intentar iniciar sesión.'),
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
                },
              ),
            ],
          ),
        ));
  }

  // Función resetPassword
  Future<void> resetPassword(BuildContext context) async {
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
                decoration:
                    const InputDecoration(hintText: 'Correo electrónico'),
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
}
