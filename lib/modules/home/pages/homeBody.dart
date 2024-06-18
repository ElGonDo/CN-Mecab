// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, avoid_print, non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnmecab/modules/profile/services/objectUser.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsResenables.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsNoResenables.dart';
import 'package:cnmecab/modules/home/components/buildersCards.dart';
import 'package:cnmecab/modules/home/components/filter_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  void actualizarLikesEnHome(int nuevosLikes, Publicacion publicacion) {
    setState(() {
      publicacion.likes = nuevosLikes;
    });
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
                      return buildCardWidget(
                          publicacionesList[index],
                          context,
                          user!.uid,
                          comentarioController,
                          URlString,
                          actualizarLikesEnHome);
                    } else {
                      int rIndex = index - publicacionesList.length;
                      String rtitulo = publicacionesListR[rIndex].rtitulo;
                      String rdescripcion =
                          publicacionesListR[rIndex].rdescripcion;
                      String pubId = publicacionesListR[rIndex].rpubID;
                      String ruid = publicacionesListR[rIndex].ruid;
                      return buildCardWidget2(
                        rtitulo,
                        rdescripcion,
                        pubId,
                        '$pubId.jpg',
                        ruid,
                        context,
                        user!.uid,
                        comentarioController,
                        URlString,
                        publicacionesListR[
                            rIndex], // Cambia 'mostrar' por 'publicacionesListR[rIndex]'
                      );
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
      return buildCardWidget2(
        rtitulo,
        rdescripcion,
        pubId,
        '$pubId.jpg',
        ruid,
        context,
        user!.uid,
        comentarioController,
        URlString,
        publicacionesListR[index],
      );
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
      return buildCardWidget2(
        rtitulo,
        rdescripcion,
        pubId,
        '$pubId.jpg',
        ruid,
        context,
        user!.uid,
        comentarioController,
        URlString,
        publicacionesListR[index],
      );
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
      return buildCardWidget2(
        rtitulo,
        rdescripcion,
        pubId,
        '$pubId.jpg',
        ruid,
        context,
        user!.uid,
        comentarioController,
        URlString,
        publicacionesListR[index],
      );
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
      return buildCardWidget2(
        rtitulo,
        rdescripcion,
        pubId,
        '$pubId.jpg',
        ruid,
        context,
        user!.uid,
        comentarioController,
        URlString,
        publicacionesListR[index],
      );
    } else {
      return Container();
    }
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
      //print('Error al obtener el nombre del usuario: $e');
    }
    return null;
  }
}
