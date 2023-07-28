// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cnmecab/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Correo Electrónico',
              ),
              controller: _emailController,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contraseña',
              ),
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Registrarse'),
              onPressed: () async {
                final String email = _emailController.text;
                final String password = _passwordController.text;

                AuthService _authService = AuthService();
                UserCredential? userCredential =
                    await _authService.register(email, password);

                if (userCredential != null) {
                  // El usuario se registró correctamente
                  // Aquí puedes redirigir al usuario a la página principal, por ejemplo
                  Navigator.of(context).pushNamed('/');
                } else {
                  // Algo salió mal
                  // Puedes mostrar un mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al registrarse')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
