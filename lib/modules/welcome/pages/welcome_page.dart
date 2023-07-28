import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Aquí puedes poner tu logo
            ElevatedButton(
              child: const Text('Iniciar sesión'),
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),
            ElevatedButton(
              child: const Text('Registrarse'),
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
            ),
          ],
        ),
      ),
    );
  }
}
