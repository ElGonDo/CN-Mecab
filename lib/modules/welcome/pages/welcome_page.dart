import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https://firebasestorage.googleapis.com/v0/b/cn-mecab-3c43c.appspot.com/o/post%2FIMG-20230918-WA0003.jpg?alt=media&token=b32dfb0a-f985-4b98-8031-3f968d7c5b1d',
              width: 380,
              height: 340,
            ),
            const SizedBox(height: 20),
            const Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 35,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('Iniciar sesión'),
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
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
