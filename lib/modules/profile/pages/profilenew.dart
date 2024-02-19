// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, prefer_const_constructors

import 'package:cnmecab/modules/profile/pages/objetoUsuario.dart';
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
  final List<Widget> paginasVisitantes = [
    // Contenido de la pestaña "Compartidos"
    Center(
      child: Text('Contenido de los Compartidos'),
    ),
    // Contenido de la pestaña "Guardados"
    Center(
      child: Text('Contenido de los guardados'),
    ),
  ];
  final List<Widget> TextoVisitantes = [
    Tab(text: 'Mis Compartidos'),
    Tab(text: 'Mis Guardados'),
  ];
  final List<Widget> paginasCreadores = [
    // Contenido de la pestaña "Publicaciones"
    Center(
      child: Text('Contenido de los Publicaciones'),
    ),
    // Contenido de la pestaña "Compartidos"
    Center(
      child: Text('Contenido de los Compartidos'),
    ),
    // Contenido de la pestaña "Guardados"
    Center(
      child: Text('Contenido de los guardados'),
    ),
  ];
  final List<Widget> TextoCreadores = [
    Tab(text: 'Mis Publicaciones'),
    Tab(text: 'Mis Compartidos'),
    Tab(text: 'Mis Guardados'),
  ];

  @override
  void initState() {
    super.initState();
    UserProfileSingleton().initializeUserProfile().then((profile) {
      setState(() {
        userProfile = profile;
        URlString = userProfile?.profileImageURL ?? '';
      });
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
              // Llamamos al método para inicializar el perfil del usuario
              UserProfile? updatedProfile =
                  await UserProfileSingleton().initializeUserProfile();
              setState(() {
                userProfile = updatedProfile;
                URlString = userProfile?.profileImageURL ?? '';
              });
              // Lógica para actualizar los datos
              return Future<void>.delayed(const Duration(seconds: 2));
            },
            displacement: 50,
            edgeOffset: 10,
            child: CustomScrollView(slivers: <Widget>[
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
                  ],
                ),
              )
            ])));
  }
}
