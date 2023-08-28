import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';

class BodyPage extends StatefulWidget {
  const BodyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaginahomeState createState() => _PaginahomeState();
}

class _PaginahomeState extends State<BodyPage> {
  String currentPage = 'Para ti';
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
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
                        ? const Color.fromARGB(255, 255, 0, 0)
                        : Colors.white,
                    minimumSize: const Size(199, 50),
                    maximumSize: const Size(200, 50),
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
                    minimumSize: const Size(199, 50),
                    maximumSize: const Size(200, 50),
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
                    minimumSize: const Size(199, 50),
                    maximumSize: const Size(200, 50),
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
                    minimumSize: const Size(199, 50),
                    maximumSize: const Size(200, 50),
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
                        ? const Color.fromARGB(255, 255, 17, 0)
                        : Colors.white,
                    minimumSize: const Size(199, 50),
                    maximumSize: const Size(200, 50),
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
          const SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                if (currentPage == 'Para ti') {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const ListTile(
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
                              icon: const Icon(Icons.thumb_up),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.comment),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.share),
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
                        const ListTile(
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
                              icon: const Icon(Icons.thumb_up),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.comment),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.share),
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
                        const ListTile(
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                          ),
                          title: Text('Serie'),
                          textColor: Color.fromARGB(255, 255, 17, 0),
                          subtitle: Text('Descripcion breve de la publicacion'),
                        ),
                        Image.network('https://via.placeholder.com/1080'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.thumb_up),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.comment),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.share),
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
                        const ListTile(
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
                              icon: const Icon(Icons.thumb_up),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.comment),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.share),
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
                        const ListTile(
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
                              icon: const Icon(Icons.thumb_up),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.comment),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.share),
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
