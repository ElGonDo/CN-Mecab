// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnmecab/modules/Post_show/show_post_Resenables.dart';
import 'package:cnmecab/modules/home/pages/comments.dart';
import 'package:cnmecab/modules/home/pages/filter_body.dart';
import 'package:cnmecab/modules/profile/pages/filterProfileServicesSaved.dart';
import 'package:cnmecab/modules/profile/pages/filterProfileServicesShared.dart';
import 'package:cnmecab/modules/profile/pages/objetoUsuario.dart';
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
  User? user = FirebaseAuth.instance.currentUser;
  String URlString = '';
  List<Publicacion> publicacionesList = [];
  List<PublicacionR> publicacionesListR = [];
  TextEditingController comentarioController = TextEditingController(text: "");
  int likes = 0;

  @override
  void initState() {
    super.initState();
    obtenerDatos().then((data) {
      setState(() {
        publicacionesList = data;
      });
    });

    obtenerDatosR().then((data) {
      setState(() {
        publicacionesListR = data;
      });
    });
    UserProfileSingleton().initializeUserProfile().then((profile) {
      setState(() {
        URlString = profile?.profileImageURL ?? '';
      });
    });
  }

  Future<int> actualizarLikes(String pubId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final reaccionesDocumentReference =
          db.collection('Reacciones').doc(pubId);
      final reaccionesDocument = await reaccionesDocumentReference.get();
      Map<String, dynamic> reaccionesData;
      if (!reaccionesDocument.exists) {
        reaccionesData = {};
      } else {
        reaccionesData = reaccionesDocument.data() as Map<String, dynamic>;
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

        await reaccionesDocumentReference.set(
            reaccionesData, SetOptions(merge: true));

        return likes; // Devuelve el nuevo contador de likes
      }
    }
    return likes; // Devuelve el contador actual de likes si no se realizó ningún cambio
  }

  /*void actualizarRating(String pubId, double rating) async {
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
  }*/

  void actualizarRating(String pubId, double rating) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Obtener la referencia del documento en la colección de Reseñas
      final reseniasDocumentReference =
          FirebaseFirestore.instance.collection('Reseñas').doc(pubId);
      final reseniasDocument = await reseniasDocumentReference.get();
      Map<String, dynamic> reseniasData;
      if (!reseniasDocument.exists) {
        // Si el documento no existe, inicializamos el mapa con la calificación actual y la ID del usuario
        reseniasData = {
          'calificaciones': {
            user.uid: rating,
          }
        };
      } else {
        // Si el documento ya existe, obtenemos los datos actuales del documento
        reseniasData = reseniasDocument.data() as Map<String, dynamic>;
        // Actualizamos el mapa con la calificación actual del usuario
        reseniasData['calificaciones'][user.uid] = rating;
      }

      // Calcular el promedio de las calificaciones
      double sumaCalificaciones = reseniasData['calificaciones']
          .values
          .reduce((value, element) => value + element);
      int cantidadCalificaciones = reseniasData['calificaciones'].length;
      double promedioCalificaciones =
          sumaCalificaciones / cantidadCalificaciones;

      // Actualizamos el mapa con el promedio de las calificaciones
      reseniasData['promedio'] = promedioCalificaciones;

      // Actualizamos el documento en la base de datos
      await reseniasDocumentReference.set(
          reseniasData, SetOptions(merge: true));
    } else {
      // Si el usuario no está autenticado, muestra un mensaje o toma otra acción según tus necesidades
      if (kDebugMode) {
        print('El usuario no está autenticado.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            obtenerDatos().then((data) {
              setState(() {
                publicacionesList = data;
              });
            });

            obtenerDatosR().then((data) {
              setState(() {
                publicacionesListR = data;
              });
            });
            UserProfileSingleton().initializeUserProfile().then((profile) {
              setState(() {
                URlString = profile?.profileImageURL ?? '';
              });
            });
          });
          // Retraso simulado durante 2 segundos antes de completar el refresh
          await Future<void>.delayed(const Duration(seconds: 2));
        },
        child: Column(
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
                      String rtitulo = publicacionesListR[rIndex].rtitulo;
                      String rdescripcion =
                          publicacionesListR[rIndex].rdescripcion;
                      String pubId = publicacionesListR[rIndex].rpubID;
                      String ruid = publicacionesListR[rIndex].ruid;
                      return buildCardWidget2(
                          rtitulo, rdescripcion, pubId, '$pubId.jpg', ruid);
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
    String ruid = publicacionesListR[index].ruid;
    // Verificar si es una película
    if (publicacionesListR[index].rcategoria == 'Películas') {
      return buildCardWidget2(rtitulo, rdescripcion, pubId, '$pubId.jpg', ruid);
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
    String ruid = publicacionesListR[index].ruid;
    // Verificar si es una serie
    if (publicacionesListR[index].rcategoria == 'Series') {
      return buildCardWidget2(rtitulo, rdescripcion, pubId, '$pubId.jpg', ruid);
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
    String ruid = publicacionesListR[index].ruid;
    // Verificar si es un libro
    if (publicacionesListR[index].rcategoria == 'Libros') {
      return buildCardWidget2(rtitulo, rdescripcion, pubId, '$pubId.jpg', ruid);
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
    String ruid = publicacionesListR[index].ruid;
    // Verificar si es un anime
    if (publicacionesListR[index].rcategoria == 'Animes') {
      return buildCardWidget2(rtitulo, rdescripcion, pubId, '$pubId.jpg', ruid);
    } else {
      return Container();
    }
  }

  Widget buildCardWidget(Publicacion publicacion) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: FutureBuilder<NetworkImage?>(
              future: obtenerImagenUrlUsuarios(publicacion.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const CircleAvatar(
                    radius: 20.0,
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/180'),
                  );
                } else {
                  return CircleAvatar(
                    radius: 20.0,
                    backgroundImage: snapshot.data!,
                  );
                }
              },
            ),
            title: Text(publicacion.titulo),
            subtitle: Text(publicacion.descripcion),
          ),
          FutureBuilder<String>(
            future: getImageUrl('${publicacion.pubID}.jpg'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
                  mostrarModalComentarios(context, publicacion.pubID,
                      comentarioController, URlString);
                },
                icon: const Icon(Icons.comment),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  compartirPublicacion(
                      context, publicacion.uid, publicacion.pubID, user!.uid);
                },
                icon: const Icon(Icons.share),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCardWidget2(String title, String description, String pubId,
      String imageName, String ruid) {
    double currentRating = 4.0;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: FutureBuilder<NetworkImage?>(
              future: obtenerImagenUrlUsuarios(ruid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const CircleAvatar(
                    radius: 20.0,
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/180'),
                  );
                } else {
                  return CircleAvatar(
                    radius: 20.0,
                    backgroundImage: snapshot.data!,
                  );
                }
              },
            ),
            title: Text(title),
            subtitle: Text(description),
          ),
          FutureBuilder<String>(
            future: getImageUrl(imageName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
                        content: Text('Calificación actualizada: $rating')),
                  );
                },
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      mostrarModalComentarios(
                          context, pubId, comentarioController, URlString);
                    },
                    icon: const Icon(Icons.comment),
                  ),
                  IconButton(
                    onPressed: () {
                      guardarPublicacion(context, ruid, pubId, user!.uid);
                    },
                    icon: const Icon(Icons.bookmark),
                  ),
                  IconButton(
                    onPressed: () {
                      compartirPublicacion(context, ruid, pubId, user!.uid);
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

Future<NetworkImage?> obtenerImagenUrlUsuarios(String uid) async {
  try {
    // Obtener el documento del usuario
    DocumentSnapshot userDocument =
        await FirebaseFirestore.instance.collection('Usuarios').doc(uid).get();

    // Verificar si el documento existe y si contiene datos
    if (userDocument.exists && userDocument.data() != null) {
      // Obtener el nombre del usuario
      Map<String, dynamic> userData =
          userDocument.data() as Map<String, dynamic>;
      String? profileImageName = await UserProfileSingleton()
          .getProfileImageName(uid, userData['Rol']);
      String? imageURL;
      if (profileImageName != null) {
        imageURL = await UserProfileSingleton()
            .getImageURLByName(profileImageName, userData['Rol']);
      }

      return NetworkImage(imageURL!);
    } else {
      // Si el documento no existe o no contiene datos, retornar null
      return null;
    }
  } catch (e) {
    // Manejar cualquier error y retornar null
    if (kDebugMode) {
      print('Error al obtener el nombre del usuario: $e');
    }
    return null;
  }
}
