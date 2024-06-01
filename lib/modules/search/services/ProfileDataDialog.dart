// ignore_for_file: file_names, avoid_print, use_build_context_synchronously, non_constant_identifier_names
import 'package:cnmecab/modules/home/components/buildersCards.dart';
import 'package:cnmecab/modules/home/pages/homeBody.dart';
import 'package:cnmecab/modules/profile/filterProfileServicesMyPublications.dart';
import 'package:cnmecab/modules/profile/services/filterProfileServicesShared.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsNoResenables.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsResenables.dart';
import 'package:cnmecab/modules/search/components/filterDataProfileSearch.dart';
import 'package:flutter/material.dart';

class ProfileDataDialog extends StatefulWidget {
  final String name;
  final String role;
  final String uid;
  final String URlString;
  final String currentUser;
  final List<Publicacion> publicacionesNR;
  final List<PublicacionR> publicacionesR;

  const ProfileDataDialog({
    Key? key,
    required this.name,
    required this.role,
    required this.uid,
    required this.URlString,
    required this.currentUser,
    required this.publicacionesNR,
    required this.publicacionesR,
  }) : super(key: key);

  @override
  ProfileDataDialogState createState() => ProfileDataDialogState();
}

class ProfileDataDialogState extends State<ProfileDataDialog> {
  String currentPage = 'Sus Compartidos';
  List<Publicacion> newPublicacionesNR = [];
  List<PublicacionR> newPublicacionesR = [];
  List<Publicacion> newMisPublicacionesNR = [];
  List<PublicacionR> newMisPublicacionesR = [];
  TextEditingController comentarioController = TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
    initializeDataDialog();
  }

  void actualizarLikesEnSearch(int nuevosLikes, Publicacion publicacion) {
    setState(() {
      publicacion.likes = nuevosLikes;
    });
  }

  Future<void> initializeDataDialog() async {
    Map<String, List<dynamic>> resultCompartidas =
        await obtenerPublicacionesCompartidas(
            widget.uid, widget.publicacionesNR, widget.publicacionesR);
    setState(() {
      newPublicacionesNR =
          resultCompartidas["publicacionesNR"] as List<Publicacion>;
      newPublicacionesR =
          resultCompartidas["publicacionesR"] as List<PublicacionR>;
    });

    Map<String, List<dynamic>> resultMisPublicaciones =
        await obtenerMisPublicaciones(
            widget.uid, widget.publicacionesNR, widget.publicacionesR);
    setState(() {
      newMisPublicacionesNR =
          resultMisPublicaciones["mispublicacionesNR"] as List<Publicacion>;
      newMisPublicacionesR =
          resultMisPublicaciones["mispublicacionesR"] as List<PublicacionR>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Perfil de ${widget.name}'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                child: FutureBuilder<NetworkImage?>(
                  future: obtenerImagenUrlUsuarios(widget.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return const CircleAvatar(
                        radius: 50.0,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/180'),
                      );
                    } else {
                      return CircleAvatar(
                        radius: 50.0,
                        backgroundImage: snapshot.data!,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(widget.role),
              const SizedBox(height: 10),
              FilterProfileSearch(
                currentPage: currentPage,
                role: widget.role,
                onPageChanged: (selectedSection) {
                  setState(() {
                    currentPage = selectedSection;
                  });
                },
                context: context,
              ),
              if (currentPage == 'Sus Compartidos')
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
                        widget.currentUser,
                        comentarioController,
                        widget.URlString,
                        publicacionR,
                      ),
                    for (var publicacionNR in newPublicacionesNR)
                      buildCardWidget(
                          publicacionNR,
                          context,
                          widget.currentUser,
                          comentarioController,
                          widget.URlString,
                          actualizarLikesEnSearch),
                  ],
                ),
              if (currentPage == 'Sus Publicaciones')
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
                        widget.currentUser,
                        comentarioController,
                        widget.URlString,
                        publicacionR,
                      ),
                    for (var publicacionNR in newMisPublicacionesNR)
                      buildCardWidget(
                          publicacionNR,
                          context,
                          widget.currentUser,
                          comentarioController,
                          widget.URlString,
                          actualizarLikesEnSearch),
                  ],
                ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
