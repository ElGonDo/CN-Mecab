// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'package:cnmecab/modules/profile/pages/objetoUsuario.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  UserProfile? userProfile;
  late int tabLength;
  late String URlString = userProfile!.profileImageURL!;

  @override
  void initState() {
    super.initState();
    // Obtener el perfil del usuario desde el Singleton
    userProfile = UserProfileSingleton().userProfile;
    tabLength = userProfile?.role == 'Visitante' ? 2 : 3;
    _tabController = TabController(length: tabLength, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      body: Column(
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
          Expanded(
            child: DefaultTabController(
              length: tabLength,
              child: Scaffold(
                appBar: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontSize: userProfile?.role == 'Visitante' ? 15 : 12,
                  ),
                  tabs: _buildTabList(userProfile),
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: _buildTabContent(userProfile),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTabList(UserProfile? userProfile) {
    if (userProfile?.role == 'Visitante') {
      return const [
        Tab(text: 'Mis Compartidos'),
        Tab(text: 'Mis Guardados'),
      ];
    } else {
      return const [
        Tab(text: 'Mis Publicaciones'),
        Tab(text: 'Mis Compartidos'),
        Tab(text: 'Mis Guardados'),
      ];
    }
  }

  List<Widget> _buildTabContent(UserProfile? userProfile) {
    if (userProfile?.role == 'Visitante') {
      return const [
        // Contenido de la pestaña "Compartidos"
        Center(
          child: Text('Contenido de los Compartidos'),
        ),
        // Contenido de la pestaña "Guardados"
        Center(
          child: Text('Contenido de los guardados'),
        ),
      ];
    } else {
      return const [
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
    }
  }
}
