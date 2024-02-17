// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnmecab/modules/Post_show/show_post_Resenables.dart';
import 'package:cnmecab/modules/home/pages/comments.dart';
import 'package:cnmecab/modules/home/pages/filter_body.dart';
import 'package:cnmecab/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

import 'package:cnmecab/modules/Post_show/show_posts_No_Resenables.dart';

class BodyPage extends StatefulWidget {
  const BodyPage({Key? key}) : super(key: key);

  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  String currentPage = 'Para ti';
  bool isDarkModeEnabled = false;
  List<Publicacion> publicacionesList = [];
  List<PublicacionR> publicacionesListR = [];
  TextEditingController comentarioController =
      TextEditingController(text: "");
      int likes = 0;

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
Future<int> actualizarLikes(String pubId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final reaccionesDocumentReference =
          db.collection('Reacciones').doc(pubId);
      final reaccionesDocument =
          await reaccionesDocumentReference.get();
      Map<String, dynamic> reaccionesData;
      if (!reaccionesDocument.exists) {
        reaccionesData = {};
      } else {
        reaccionesData =
            reaccionesDocument.data() as Map<String, dynamic>;
      }

      if (reaccionesData != null && pubId != null) {
        int likes = reaccionesData['likes'] ?? 0;

        List<dynamic> usuariosQueDieronLikeDynamic =
            reaccionesData['usuarios_que_dieron_like'] ?? [];

        List<String> usuariosQueDieronLike =
            usuariosQueDieronLikeDynamic.cast<String>();

        if (usuariosQueDieronLike.contains(user.uid)) {
          // El usuario ya dio like, entonces se quitará
          likes--;
          usuariosQueDieronLike.remove(user.uid);
        } else {
          // El usuario no había dado like, entonces se agregará
          likes++;
          usuariosQueDieronLike.add(user.uid);
        }

        reaccionesData = {
          'likes': likes,
          'usuarios_que_dieron_like': usuariosQueDieronLike,
        };

        await reaccionesDocumentReference
            .set(reaccionesData, SetOptions(merge: true));

        return likes; // Devuelve el nuevo contador de likes
      }
    }
    return likes; // Devuelve el contador actual de likes si no se realizó ningún cambio
  }

  void actualizarRating(String pubId, double rating) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final reseniasDocumentReference =
          FirebaseFirestore.instance.collection('Reseñas').doc(pubId);
      final reseniasDocument = await reseniasDocumentReference.get();
      Map<String, dynamic> reseniasData;
      if (!reseniasDocument.exists) {
        reseniasData = {
          'calificaciones': {
            user.uid: rating,
          },
          'numero_calificaciones': 1,
        };
      } else {
        reseniasData = reseniasDocument.data() as Map<String, dynamic>;
        reseniasData['calificaciones'][user.uid] = rating;
        reseniasData['numero_calificaciones'] =
            (reseniasData['numero_calificaciones'] ?? 0) + 1;
      }

      double totalRating = 0;
      reseniasData['calificaciones'].forEach((_, value) {
        totalRating += value;
      });
      double promedioRating =
          totalRating / (reseniasData['numero_calificaciones'] ?? 1);

      await reseniasDocumentReference.set({
        'calificaciones': reseniasData['calificaciones'],
        'numero_calificaciones': reseniasData['numero_calificaciones'],
        'promedio_rating': promedioRating,
      });
    } else {
      if (kDebugMode) {
        print('El usuario no está autenticado.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20.0),
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
              itemCount: currentPage == 'Para ti'
                  ? publicacionesList.length + publicacionesListR.length
                  : publicacionesListR.length,
              itemBuilder: (context, index) {
                if (currentPage == 'Para ti') {
                  if (index < publicacionesList.length) {
                   return buildCardWidget(publicacionesList[index]);
                  } else {
                    int rIndex = index - publicacionesList.length;
                    String rtitulo =
                        publicacionesListR[rIndex].rtitulo;
                    String rdescripcion =
                        publicacionesListR[rIndex].rdescripcion;
                    String pubId =
                        publicacionesListR[rIndex].rpubID;
                    return buildCardWidget2(
                        rtitulo, rdescripcion, pubId, '$pubId.jpg');
                  }
                } else if (currentPage == 'Películas') {
                  return buildPeliculasWidget(index);
                } else if (currentPage == 'Series') {
                  return buildSeriesWidget(index);
                } else if (currentPage == 'Libros') {
                  return buildLibrosWidget(index);
                } else if (currentPage == 'Animes') {
                  return buildAnimesWidget(index);
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

  Widget buildPeliculasWidget(int index) {
    if (index >= publicacionesListR.length) {
      return Container();
    }
    String rtitulo = publicacionesListR[index].rtitulo;
    String rdescripcion = publicacionesListR[index].rdescripcion;
    String pubId = publicacionesListR[index].rpubID;
    // Verificar si es una película
    if (publicacionesListR[index].rcategoria == 'Películas') {
      return buildCardWidget2(rtitulo, rdescripcion, pubId, '$pubId.jpg');
    } else {
      return Container();
    }
  }

  Widget buildSeriesWidget(int index) {
    if (index >= publicacionesListR.length) {
      return Container();
    }
    String rtitulo = publicacionesListR[index].rtitulo;
    String rdescripcion = publicacionesListR[index].rdescripcion;
    String pubId = publicacionesListR[index].rpubID;
    // Verificar si es una serie
    if (publicacionesListR[index].rcategoria == 'Series') {
      return buildCardWidget2(rtitulo, rdescripcion, pubId, '$pubId.jpg');
    } else {
      return Container();
    }
  }

  Widget buildLibrosWidget(int index) {
    if (index >= publicacionesListR.length) {
      return Container();
    }
    String rtitulo = publicacionesListR[index].rtitulo;
    String rdescripcion = publicacionesListR[index].rdescripcion;
    String pubId = publicacionesListR[index].rpubID;
    // Verificar si es un libro
    if (publicacionesListR[index].rcategoria == 'Libros') {
      return buildCardWidget2(rtitulo, rdescripcion, pubId, '$pubId.jpg');
    } else {
      return Container();
    }
  }

  Widget buildAnimesWidget(int index) {
    if (index >= publicacionesListR.length) {
      return Container();
    }
    String rtitulo = publicacionesListR[index].rtitulo;
    String rdescripcion = publicacionesListR[index].rdescripcion;
    String pubId = publicacionesListR[index].rpubID;
    // Verificar si es un anime
    if (publicacionesListR[index].rcategoria == 'Animes') {
      return buildCardWidget2(rtitulo, rdescripcion, pubId, '$pubId.jpg');
    } else {
      return Container();
    }
  }

  Widget buildCardWidget(Publicacion publicacion) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'ID de la publicación: ${publicacion.pubID}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/180'),
            ),
            title: Text(publicacion.titulo),
            subtitle: Text(publicacion.descripcion),
          ),
          FutureBuilder<String>(
            future: getImageUrl('${publicacion.pubID}.jpg'),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return const Text('Error cargando la imagen');
              } else {
                return Image.network(snapshot.data!);
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  actualizarLikes(publicacion.pubID).then((value) {
                    setState(() {
                      publicacion.likes = value;
                    });
                  });
                },
                icon: const Icon(Icons.thumb_up),
                
              ),
              Text('Likes: ${publicacion.likes}'),
              IconButton(
                onPressed: () {
                  mostrarModalComentarios(
                      context, publicacion.pubID, comentarioController);
                },
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

  Widget buildCardWidget2(String title, String description,
      String pubId, String imageName) {
    double currentRating = 4.0;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'ID de la publicación: $pubId',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/180'),
            ),
            title: Text(title),
            subtitle: Text(description),
          ),
          FutureBuilder<String>(
            future: getImageUrl(imageName),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return const Text('Error cargando la imagen');
              } else {
                return Image.network(snapshot.data!);
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RatingBar.builder(
                initialRating: currentRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 255, 0, 0),
                ),
                onRatingUpdate: (rating) {
                  currentRating = rating;
                  actualizarRating(pubId, rating);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Calificación actualizada: $rating')),
                  );
                },
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      mostrarModalComentarios(
                          context, pubId, comentarioController);
                    },
                    icon: const Icon(Icons.comment),
                  ),
                  IconButton(
                    onPressed: () {
                      // Aquí puedes agregar la lógica para guardar
                    },
                    icon: const Icon(Icons.bookmark),
                  ),
                  IconButton(
                    onPressed: () {
                      // Aquí puedes agregar la lógica para guardar
                    },
                    icon: const Icon(Icons.share),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
