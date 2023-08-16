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
        title: Text(
          'Iniciar Sesión',
          style: TextStyle(
            fontSize: 20, // Tamaño de fuente del título
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black, // Color de fondo negro para la barra
        centerTitle: true, // Centra el título en la barra de navegación
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centra el contenido verticalmente
          children: <Widget>[
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
            SizedBox(height: 30), // Espacio entre el título y los campos
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
              style: ElevatedButton.styleFrom(
                primary:
                    Colors.red, // Cambia el color de fondo del botón a rojo
              ),
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(fontSize: 18), // Tamaño de fuente del botón
              ),
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
                  // Puedes mostrar un mensaje de error en una ventana emergente
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error al iniciar sesión'),
                        content: Text(
                            'Ocurrió un error al intentar iniciar sesión.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cerrar'),
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
      ),
    );
  }
}
