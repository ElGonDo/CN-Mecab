import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Oculta la barra de navegación superior
        toolbarHeight: 0,
        backgroundColor:
            Colors.black, // Cambia el color del fondo de la barra superior
      ),
      backgroundColor: Colors.black, // Cambia el color de fondo de la pantalla
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 200, // Ajusta el ancho de tu logo según sea necesario
              height: 200, // Ajusta la altura de tu logo según sea necesario
              // child: YourLogoWidget(),  // Reemplaza con tu widget de logo
            ),
            const SizedBox(height: 20), // Espacio entre el logo y los botones
            const Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'CN',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue, // Color azul para "CN"
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' MECAB',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.red, // Color rojo para "MECAB"
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Cambia el color de fondo del botón
                onPrimary: Colors.white, // Cambia el color del texto del botón
              ),
              child: const Text('Iniciar sesión'),
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),
            const SizedBox(height: 20), // Espacio entre los botones
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Cambia el color de fondo del botón
                onPrimary: Colors.white, // Cambia el color del texto del botón
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
