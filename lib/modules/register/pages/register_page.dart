import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        centerTitle: true, // Centra el título en la barra de navegación
        backgroundColor: Colors.black, // Color de fondo negro para la barra
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
              style: ElevatedButton.styleFrom(
                primary:
                    Colors.red, // Cambia el color de fondo del botón a rojo
              ),
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
                  Navigator.of(context).pushNamed('/home');
                } else {
                  // Algo salió mal
                  // Puedes mostrar un mensaje de error en una ventana emergente
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error al registrarse'),
                        content:
                            Text('Ocurrió un error al intentar registrarse.'),
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
