// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, non_constant_identifier_names, avoid_print
import 'package:cnmecab/modules/profile/filterProfileServicesMyPublications.dart';
import 'package:cnmecab/modules/profile/services/filterProfileServicesSaved.dart';
import 'package:cnmecab/modules/profile/services/filterProfileServicesShared.dart';
import 'package:cnmecab/modules/profile/services/objectUser.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsResenables.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsNoResenables.dart';
import 'package:cnmecab/modules/home/components/buildersCards.dart';
import 'package:cnmecab/modules/profile/components/filterprofile.dart';
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
    refreshProfileData();
  }

  void actualizarLikesEnPerfil(int nuevosLikes, Publicacion publicacion) {
    setState(() {
      publicacion.likes = nuevosLikes;
    });
  }

  Future<void> refreshProfileData() async {
    UserProfile? updatedProfile =
        await UserProfileSingleton().initializeUserProfile();
    setState(() {
      userProfile = updatedProfile;
      URlString = userProfile?.profileImageURL ?? '';
    });

    List<dynamic> values = await Future.wait([obtenerDatos(), obtenerDatosR()]);
    publicacionesList = values[0] as List<Publicacion>;
    publicacionesListR = values[1] as List<PublicacionR>;

    Map<String, List<dynamic>> resultCompartidas =
        await obtenerPublicacionesCompartidas(
            user!.uid, publicacionesList, publicacionesListR);
    setState(() {
      newPublicacionesNR =
          resultCompartidas["publicacionesNR"] as List<Publicacion>;
      newPublicacionesR =
          resultCompartidas["publicacionesR"] as List<PublicacionR>;
    });

    Map<String, List<dynamic>> resultMisPublicaciones =
        await obtenerMisPublicaciones(
            user!.uid, publicacionesList, publicacionesListR);
    setState(() {
      newMisPublicacionesNR =
          resultMisPublicaciones["mispublicacionesNR"] as List<Publicacion>;
      newMisPublicacionesR =
          resultMisPublicaciones["mispublicacionesR"] as List<PublicacionR>;
      print('Contenido de Mis Publicaciones: $newMisPublicacionesR');
      print('Contenido de Mis Publicaciones no : $newMisPublicacionesNR');
    });

    List<PublicacionR> valueGuardadas =
        await obtenerPublicacionesGuardadas(user!.uid, publicacionesListR);
    setState(() {
      newPublicacionesGuardadasR = valueGuardadas;
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
          refreshProfileData();
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
                                userProfile?.role == 'Visitante'
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
                            URlString,
                            publicacionR,
                          ),
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
                            URlString,
                            publicacionR,
                          ),
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
                            URlString,
                            publicacionGuardada,
                          ),
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
