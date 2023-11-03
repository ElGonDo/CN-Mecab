import 'package:cnmecab/modules/Post_show/show_post_Resenables.dart';
import 'package:cnmecab/modules/home/pages/filter_body.dart';
//import 'package:cnmecab/services/firebase_services.dart';
import 'package:flutter/material.dart';
// Importa la clase FilterBody
import 'package:cnmecab/modules/Post_show/show_posts_No_Resenables.dart';

class BodyPage extends StatefulWidget {
  const BodyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaginahomeState createState() => _PaginahomeState();
}

class _PaginahomeState extends State<BodyPage> {
  String currentPage = 'Para ti';
  bool isDarkModeEnabled = false;
  List<Publicacion> publicacionesList = [];
  List<PublicacionR> publicacionesListR = [];
   @override
  void initState() {
    super.initState();
    obtenerDatos((data) {
      setState(() {
        publicacionesList = data;
      });
    });
    obtenerDatosR((data) {
      setState(() {
        publicacionesListR = data;
      });
    });
  }
  
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
    itemCount: currentPage == 'Para ti' ? publicacionesList.length + publicacionesListR.length : publicacionesListR.length,
    itemBuilder: (context, index) {
      // Agrega aquí el contenido específico para cada página
      if (currentPage == 'Para ti') {
        if (index < publicacionesList.length) {
          // Esto es para mostrar el contenido de publicacionesList
          String titulo = publicacionesList[index].titulo;
          String descripcion = publicacionesList[index].descripcion;
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage('https://via.placeholder.com/180'),
                  ),
                  title: Text(titulo),
                  subtitle: Text(descripcion),
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
          // Esto es para mostrar el contenido de publicacionesListR
          int rIndex = index - publicacionesList.length;
          String rtitulo = publicacionesListR[rIndex].rtitulo;
          String rdescripcion = publicacionesListR[rIndex].rdescripcion;
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage('https://via.placeholder.com/180'),
                  ),
                  title: Text(rtitulo),
                  subtitle: Text(rdescripcion),
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
        }
      } else if (currentPage == 'Películas') {
        // Código para la página de películas
        String rtitulo = publicacionesListR[index].rtitulo;
        String rdescripcion = publicacionesListR[index].rdescripcion;
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage('https://via.placeholder.com/180'),
                ),
                title: Text(rtitulo),
                subtitle: Text(rdescripcion),
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
