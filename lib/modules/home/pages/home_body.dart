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
                          title: Text('Bohemian Rhapsody'),
                          textColor: Color.fromARGB(255, 0, 0, 0),
                          subtitle: Text(
                              'Una pelicula que relata la vida de Fredy Mercury '),
                        ),
                        Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/cn-mecab-3c43c.appspot.com/o/post%2F1000000037.jpg?alt=media&token=e16e6551-7fa4-4d0c-bd40-c45af6429b5b'),
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
                          title: Text('Rick and Morty'),
                          textColor: Color.fromARGB(255, 255, 17, 0),
                          subtitle: Text('Serie de HBO'),
                        ),
                        Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/cn-mecab-3c43c.appspot.com/o/post%2F1000000040.jpg?alt=media&token=a1284e33-f9d6-49fb-8695-0912bafeab65'),
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
                          title: Text('Las Ventajas de Ser Invisible'),
                          textColor: Color.fromARGB(255, 93, 168, 82),
                          subtitle: Text(
                              'Sigue esta bella historia creada por Stephen Chbosky '),
                        ),
                        Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/cn-mecab-3c43c.appspot.com/o/post%2F1000000041.jpg?alt=media&token=b39870b2-ffd1-4209-85dd-4df9011c67fc'),
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
                          title: Text('Jujutsu Kaisen'),
                          textColor: Color.fromARGB(255, 196, 145, 2),
                          subtitle: Text(
                              'Fuertes criticas al ultimo episodio de jujutsu kaisen por su efecto de ghosting'),
                        ),
                        Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/cn-mecab-3c43c.appspot.com/o/post%2F1000000042.jpg?alt=media&token=f5816af9-ab00-4e5b-90e8-335d6324654b'),
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
