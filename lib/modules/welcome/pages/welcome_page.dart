import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                'https://firebasestorage.googleapis.com/v0/b/cn-mecab-3c43c.appspot.com/o/recursos%2FLogo%202.png?alt=media&token=fe4acb5b-9b27-48a2-b3b8-7313dad7ce40',
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
      ),
    );
  }
}
