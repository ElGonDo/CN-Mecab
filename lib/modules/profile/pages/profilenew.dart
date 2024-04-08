// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, non_constant_identifier_names, avoid_print
import 'package:cnmecab/modules/Post_show/show_post_Resenables.dart';
import 'package:cnmecab/modules/Post_show/show_posts_No_Resenables.dart';
import 'package:cnmecab/modules/home/pages/buildersCards.dart';
import 'package:cnmecab/modules/profile/pages/filterProfileServicesMyPublications.dart';
import 'package:cnmecab/modules/profile/pages/filterProfileServicesSaved.dart';
import 'package:cnmecab/modules/profile/pages/filterProfileServicesShared.dart';
import 'package:cnmecab/modules/profile/pages/filterprofile.dart';
import 'package:cnmecab/modules/profile/pages/objetoUsuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  UserProfile? userProfile;
  late int tabLength;
  late String URlString = "";
  TextEditingController comentarioController = TextEditingController(text: "");
  List<Publicacion> newPublicacionesNR = [];
  List<PublicacionR> newPublicacionesR = [];
  List<PublicacionR> newPublicacionesGuardadasR = [];
  List<Publicacion> publicacionesList = [];
  List<PublicacionR> publicacionesListR = [];
  List<Publicacion> newMisPublicacionesNR = [];
  List<PublicacionR> newMisPublicacionesR = [];
  User? user = FirebaseAuth.instance.currentUser;
  late String currentPage =
      'Mis Guardados'; // Variable para controlar la página actual

  @override
  void initState() {
    super.initState();
    UserProfileSingleton().initializeUserProfile().then((profile) {
      setState(() {
        userProfile = profile;
        URlString = userProfile?.profileImageURL ?? '';
      });
    });
    Future.wait([obtenerDatos(), obtenerDatosR()]).then((List<dynamic> values) {
      publicacionesList = values[0] as List<Publicacion>;
      publicacionesListR = values[1] as List<PublicacionR>;
      obtenerPublicacionesCompartidas(
              user!.uid, publicacionesList, publicacionesListR)
          .then((Map<String, List<dynamic>> result) {
        setState(() {
          newPublicacionesNR = result["publicacionesNR"] as List<Publicacion>;
          newPublicacionesR = result["publicacionesR"] as List<PublicacionR>;
        });
      });
      obtenerMisPublicaciones(user!.uid, publicacionesList, publicacionesListR)
          .then((Map<String, List<dynamic>> result) {
        setState(() {
          newMisPublicacionesNR =
              result["mispublicacionesNR"] as List<Publicacion>;
          newMisPublicacionesR =
              result["mispublicacionesR"] as List<PublicacionR>;
          print('Contenido de Mis Publicaciones: $newMisPublicacionesR');
          print('Contenido de Mis Publicaciones no : $newMisPublicacionesNR');
        });
      });
      obtenerPublicacionesGuardadas(user!.uid, publicacionesListR)
          .then((value) {
        setState(() {
          newPublicacionesGuardadasR = value;
        });
      });
    });
  }

  void actualizarLikesEnPerfil(int nuevosLikes, Publicacion publicacion) {
    setState(() {
      publicacion.likes = nuevosLikes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/Profile');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          UserProfile? updatedProfile =
              await UserProfileSingleton().initializeUserProfile();
          setState(() {
            userProfile = updatedProfile;
            URlString = userProfile?.profileImageURL ?? '';
          });
          return Future<void>.delayed(const Duration(seconds: 2));
        },
        displacement: 50,
        edgeOffset: 10,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(URlString),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                currentPage == 'Visitante'
                                    ? "/imagesprofileVisitor"
                                    : "/imagesprofileCreators",
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userProfile?.name ?? 'Nombre de Usuario',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilterProfile(
                    currentPage:
                        currentPage, // Pasa la página actual al FilterProfile
                    userRole: userProfile?.role ??
                        'Visitante', // Pasa el rol del usuario al FilterProfile
                    onPageChanged: (newPage) {
                      setState(() {
                        currentPage =
                            newPage; // Actualiza la página actual al cambiar de sección
                      });
                    },
                  ),
                  if (currentPage == 'Mis Compartidos')
                    Column(
                      children: [
                        for (var publicacionR in newPublicacionesR)
                          buildCardWidget2(
                              publicacionR.rtitulo,
                              publicacionR.rdescripcion,
                              publicacionR.rpubID,
                              '${publicacionR.rpubID}.jpg',
                              publicacionR.ruid,
                              context,
                              user!.uid,
                              comentarioController,
                              URlString),
                        for (var publicacionNR in newPublicacionesNR)
                          buildCardWidget(
                              publicacionNR,
                              context,
                              user!.uid,
                              comentarioController,
                              URlString,
                              actualizarLikesEnPerfil),
                      ],
                    ),
                  if (currentPage == 'Mis Publicaciones')
                    Column(
                      children: [
                        for (var publicacionR in newMisPublicacionesR)
                          buildCardWidget2(
                              publicacionR.rtitulo,
                              publicacionR.rdescripcion,
                              publicacionR.rpubID,
                              '${publicacionR.rpubID}.jpg',
                              publicacionR.ruid,
                              context,
                              user!.uid,
                              comentarioController,
                              URlString),
                        for (var publicacionNR in newMisPublicacionesNR)
                          buildCardWidget(
                              publicacionNR,
                              context,
                              user!.uid,
                              comentarioController,
                              URlString,
                              actualizarLikesEnPerfil),
                      ],
                    ),
                  if (currentPage == 'Mis Guardados')
                    Column(
                      children: [
                        for (var publicacionGuardada
                            in newPublicacionesGuardadasR)
                          buildCardWidget2(
                              publicacionGuardada.rtitulo,
                              publicacionGuardada.rdescripcion,
                              publicacionGuardada.rpubID,
                              '${publicacionGuardada.rpubID}.jpg',
                              publicacionGuardada.ruid,
                              context,
                              user!.uid,
                              comentarioController,
                              URlString),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
