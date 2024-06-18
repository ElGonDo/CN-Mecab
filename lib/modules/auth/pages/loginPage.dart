// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, file_names

import 'package:cnmecab/modules/auth/components/PasswordField.dart';
import 'package:cnmecab/modules/auth/services/authResetPassword.dart';
import 'package:cnmecab/modules/auth/services/authService.dart';
import 'package:cnmecab/modules/profile/services/objectUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Iniciar Sesión',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
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
                  key: const Key('emailField'),
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Correo Electrónico',
                  ),
                ),
                const SizedBox(height: 10),
                PasswordField(
                  key: const Key('passwordField'),
                  controller: _passwordController,
                  labelText: 'Contraseña',
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    resetPassword(context, auth);
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
                        await _authService.login(email, password, context);

                    if (userCredential != null) {
                      UserProfileSingleton().initializeUserProfile();
                      Navigator.of(context).pushNamed('/home');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
