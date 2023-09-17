// ignore_for_file: unnecessary_import, implementation_imports, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, file_names, use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_print, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnmecab/modules/Notification/pages/Notification.dart';
import 'package:cnmecab/modules/PostUp/pages/PostsUpload.dart';
import 'package:cnmecab/modules/home/pages/home_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Paginahome extends StatefulWidget {
  const Paginahome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaginahomeState createState() => _PaginahomeState();
}

class _PaginahomeState extends State<Paginahome> {
  Future<bool> solicitarAutenticacion() async {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    try {
      // Mostrar el diálogo emergente para ingresar el correo y contraseña
      var result = await showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: Text('Ingrese sus credenciales'),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                onChanged: (String? newValue) {
                  setState(() {
                    emailController.text = newValue ?? '';
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                controller: passwordController,
                onChanged: (String? newValue) {
                  setState(() {
                    passwordController.text = newValue ?? '';
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            BasicDialogAction(
              title: Text('Aceptar'),
              onPressed: () {
                // Cerrar el diálogo emergente y continuar con la autenticación
                Navigator.pop(context, true);
              },
            ),
            BasicDialogAction(
              title: Text('Cancelar'),
              onPressed: () {
                // Cerrar el diálogo emergente sin realizar la autenticación
                Navigator.pop(context, false);
              },
            ),
          ],
        ),
      );

      // Verificar si el usuario aceptó el diálogo emergente
      if (result == true) {
        // Obtener los datos ingresados por el usuario
        String email = emailController.text;
        String password = passwordController.text;

        // Autenticar al usuario nuevamente
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // La autenticación fue exitosa
        return true;
      } else {
        // El usuario canceló el diálogo emergente
        return false;
      }
    } catch (error) {
      // Ocurrió un error durante la autenticación
      print('Error de autenticación: $error');
      // Puedes mostrar un mensaje de error al usuario o realizar alguna otra acción

      return false;
    }
  }

  String currentPage = 'Para ti';
  bool isDarkModeEnabled = false;
  int navegador = 0;
  final List<Widget> _paginas = [
    BodyPage(),
    Publicar(),
    Notificacion(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'CN',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' MECAB',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // Acción para realizar la búsqueda
            },
          ),
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/Profile');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                'Nombre de Productora',
                style:
                    TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
              ),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text('Cuenta', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.of(context).pushNamed('/Profile');
              },
            ),
            ListTile(
              title:
                  Text('Cambiar Tema', style: TextStyle(color: Colors.black)),
              onTap: () {
                setState(() {
                  isDarkModeEnabled = !isDarkModeEnabled;
                  // Aplicar tema oscuro o claro según el estado
                  if (isDarkModeEnabled) {
                    // Configurar tema oscuro
                    // ...
                    // Por ejemplo:
                    // ThemeMode.dark
                  } else {
                    // Configurar tema claro
                    // ...
                    // Por ejemplo:
                    // ThemeMode.light
                  }
                });
              },
            ),
            ListTile(
              title: Text('Terminos y Políticas de Seguridad',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Cn Mecab',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      'Ag System Information ${DateTime.now().year} Cn Mecab',
                  //applicationIcon:
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/politics');
                      },
                      child: const Text('Politicas de Privacidad'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/terms');
                      },
                      child: const Text('Terminos y condiciones'),
                    ),
                  ],
                );
              },
            ),
            ListTile(
              title: Text('Guardados', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.of(context).pushNamed('/saved');
              },
            ),
            ListTile(
              title:
                  Text('Cerrar Sesión', style: TextStyle(color: Colors.black)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/welcome');
              },
            ),
            ListTile(
              title:
                  Text('Borrar Cuenta', style: TextStyle(color: Colors.black)),
              onTap: () async {
                // Invocar al método para solicitar autenticación nuevamente
                bool success = await solicitarAutenticacion();

                if (success) {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  await FirebaseFirestore.instance
                      .collection('Usuarios')
                      .doc(currentUser?.uid)
                      .update({
                    'Activo': false,
                  });
                  // Si la autenticación es exitosa, eliminar la cuenta y actualizar
                  await FirebaseAuth.instance.currentUser!.delete();
                  Navigator.of(context).pushReplacementNamed('/welcome');
                } else {
                  // Si la autenticación no es exitosa, realizar alguna acción adicional o mostrar un mensaje de error al usuario
                }
              },
            ),
          ],
        ),
      ),
      body: _paginas[navegador],
      bottomNavigationBar: SalomonBottomBar(
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        backgroundColor: Colors.black,
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        onTap: (index) {
          setState(() {
            navegador = index;
          });
        },
        currentIndex: navegador,
        items: [
          SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("home"),
              selectedColor: Color.fromARGB(255, 156, 37, 37)),
          SalomonBottomBarItem(
              icon: Icon(Icons.file_upload_outlined),
              title: Text("Subir Publicaciones"),
              selectedColor: Color.fromARGB(255, 156, 37, 37)),
          SalomonBottomBarItem(
              icon: Icon(Icons.notifications),
              title: Text("Notificaciones"),
              selectedColor: Color.fromARGB(255, 156, 37, 37)),
        ],
      ),
    );
  }
}
