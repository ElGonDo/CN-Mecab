import 'package:cnmecab/modules/home/pages/filter_body.dart';
//import 'package:cnmecab/services/firebase_services.dart';
import 'package:flutter/material.dart';
 // Importa la clase FilterBody

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
          FilterBody(
            currentPage: currentPage,
            onPageChanged: (newPage) {
              setState(() {
                currentPage = newPage;
              });
            },
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                // Agrega aquí el contenido específico para cada página
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
                      /* FutureBuilder(
                         future: getPubliR(), 
                         builder: ((context, snapshot){
                          return ListView.builder(
                         itemCount: snapshot.data?.length,
                         itemBuilder: (context, index){
                          return Text(snapshot.data?[index]['Titulo']);
                },
                );
            })),*/
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
