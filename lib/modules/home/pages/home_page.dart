// ignore_for_file: unnecessary_import, implementation_imports, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';

class Paginahome extends StatelessWidget {
  const Paginahome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text('CN MECABs')),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Menú',
                style: TextStyle(fontSize: 20),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Cerrar Sesión'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/welcome');
              },
            ),
            ListTile(
              title: Text('Cuenta'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Más'),
              onTap: () {},
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
                    // Acción al presionar el botón "Para ti"
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Para ti',
                    style: TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción al presionar el botón "Películas"
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Peliculas',
                    style: TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción al presionar el botón "Series"
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Series',
                    style: TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción al presionar el botón "Libros"
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Libros',
                    style: TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción al presionar el botón "Animes"
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Animes',
                    style: TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
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
                        title: Text('Universal Studio'),
                        subtitle: Text('Presentamos Rapidos y Furiosos X'),
                      ),
                      Image.network('https://via.placeholder.com/350'),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
