// ignore_for_file: unnecessary_import, implementation_imports, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, file_names, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:cnmecab/modules/Notification/pages/Notification.dart';
import 'package:cnmecab/modules/PostUp/pages/PostsUpload.dart';
import 'package:cnmecab/modules/home/home_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Paginahome extends StatefulWidget {
  const Paginahome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaginahomeState createState() => _PaginahomeState();
}

class _PaginahomeState extends State<Paginahome> {
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
              onTap: () {},
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
