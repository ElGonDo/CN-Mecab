// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cnmecab/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
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
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Iniciar Sesión'),
              onPressed: () async {
                final String email = _emailController.text;
                final String password = _passwordController.text;

                AuthService _authService = AuthService();
                UserCredential? userCredential =
                    await _authService.login(email, password);

                if (userCredential != null) {
                  // El usuario inició sesión correctamente
                  // Aquí puedes redirigir al usuario a la página principal, por ejemplo
                  Navigator.of(context).pushNamed('/home');
                } else {
                  // Algo salió mal
                  // Puedes mostrar un mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al iniciar sesión')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
