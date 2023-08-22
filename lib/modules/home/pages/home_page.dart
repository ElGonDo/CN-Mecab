// ignore_for_file: unnecessary_import, implementation_imports, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, file_names, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';

class Paginahome extends StatefulWidget {
  const Paginahome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaginahomeState createState() => _PaginahomeState();
}

class _PaginahomeState extends State<Paginahome> {
  String currentPage = 'Para ti';
  bool isDarkModeEnabled = false;

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
              // Acción para mostrar el perfil
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
              title: Text('Políticas de Seguridad',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                // Acción para mostrar las políticas de seguridad
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
              title: Text('Guardados', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Acción para la opción "Guardados"
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 'Para ti';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPage == 'Para ti'
                        ? Color.fromARGB(255, 255, 0, 0)
                        : Colors.white,
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Para ti',
                    style: TextStyle(
                      fontSize: 15,
                      color: currentPage == 'Para ti'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 'Películas';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        currentPage == 'Películas' ? Colors.red : Colors.white,
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Películas',
                    style: TextStyle(
                      fontSize: 15,
                      color: currentPage == 'Películas'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 'Series';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        currentPage == 'Series' ? Colors.red : Colors.white,
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Series',
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          currentPage == 'Series' ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 'Libros';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        currentPage == 'Libros' ? Colors.red : Colors.white,
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Libros',
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          currentPage == 'Libros' ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 'Animes';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPage == 'Animes'
                        ? Color.fromARGB(255, 255, 17, 0)
                        : Colors.white,
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Animes',
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          currentPage == 'Animes' ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                if (currentPage == 'Para ti') {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/180'),
                          ),
                          title: Text('Promotora'),
                          subtitle: Text('Descripcion breve de la publicacion'),
                        ),
                        Image.network('https://via.placeholder.com/1080'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.thumb_up),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.comment),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.share),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (currentPage == 'Películas') {
                  // Código para la página de películas
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                          ),
                          title: Text('Pelicula'),
                          textColor: Colors.blue,
                          subtitle: Text('Descripcion breve de la publicacion'),
                        ),
                        Image.network('https://via.placeholder.com/1080'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.thumb_up),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.comment),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.share),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (currentPage == 'Series') {
                  // Código para la página de series
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                          ),
                          title: Text('Serie'),
                          textColor: const Color.fromARGB(255, 255, 17, 0),
                          subtitle: Text('Descripcion breve de la publicacion'),
                        ),
                        Image.network('https://via.placeholder.com/1080'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.thumb_up),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.comment),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.share),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (currentPage == 'Libros') {
                  // Código para la página de libros
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                          ),
                          title: Text('Libro'),
                          textColor: Color.fromARGB(255, 93, 168, 82),
                          subtitle: Text('Descripcion breve de la publicacion'),
                        ),
                        Image.network('https://via.placeholder.com/1080'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.thumb_up),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.comment),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.share),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (currentPage == 'Animes') {
                  // Código para la página de animes
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                          ),
                          title: Text('Anime'),
                          textColor: Color.fromARGB(255, 196, 145, 2),
                          subtitle: Text('Descripcion breve de la publicacion'),
                        ),
                        Image.network('https://via.placeholder.com/1080'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.thumb_up),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.comment),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.share),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
