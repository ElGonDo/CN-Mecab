// ignore_for_file: file_names, use_build_context_synchronously, prefer_const_constructors

import 'package:cnmecab/modules/home/pages/homeBody.dart';
import 'package:cnmecab/modules/home/pages/homePage.dart';
import 'package:cnmecab/modules/home/services/deletePublication.dart';
import 'package:cnmecab/modules/profile/services/filterProfileServicesSaved.dart';
import 'package:cnmecab/modules/profile/services/filterProfileServicesShared.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsNoResenables.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsResenables.dart';
import 'package:cnmecab/modules/home/components/comments.dart';
import 'package:cnmecab/modules/home/updateLikesAndRating.dart';
import 'package:cnmecab/modules/publications/postPublications/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Widget buildCardWidget(
  Publicacion publicacion,
  BuildContext context,
  String uidUsuarioActual,
  TextEditingController comentarioController,
  String urlString,
  Function(int, Publicacion) actualizarLikesCallback,
) {
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
          trailing: publicacion.uid == uidUsuarioActual
              ? PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) async {
                    if (value == 'eliminar') {
                      bool eliminacionExitosa =
                          await eliminarPublicacionNoResenable(
                              publicacion.uid, publicacion.pubID);
                      if (eliminacionExitosa) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Tu publicación se borró correctamente')),
                        );
                        // Recargar la página para reflejar los cambios
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Paginahome()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Error al eliminar la publicación')),
                        );
                      }
                    } else if (value == 'editar') {
                      // Agregar la lógica para editar aquí
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'eliminar',
                      child: Text('Eliminar'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'editar',
                      child: Text('Editar'),
                    ),
                  ],
                )
              : null,
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
                  actualizarLikesCallback(value, publicacion);
                });
              },
              icon: const Icon(Icons.thumb_up),
            ),
            Text('Likes: ${publicacion.likes}'),
            IconButton(
              onPressed: () {
                mostrarModalComentarios(context, publicacion.pubID,
                    comentarioController, urlString);
              },
              icon: const Icon(Icons.comment),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                compartirPublicacion(context, publicacion.uid,
                    publicacion.pubID, uidUsuarioActual);
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildCardWidget2(
  String rtitle,
  String rdescription,
  String pubId,
  String imageName,
  String ruid,
  BuildContext context,
  String uidUsuarioActual,
  TextEditingController comentarioController,
  String urlString,
  PublicacionR mostrar,
) {
  double currentRating = mostrar.promedioResenas;
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
          title: Text(rtitle),
          subtitle: Text(rdescription),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'eliminar') {
                bool eliminacionExitosa =
                    await eliminarPublicacion(ruid, pubId);
                if (eliminacionExitosa) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Tu publicación se borró correctamente')),
                  );
                  // Recargar la página para reflejar los cambios
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Paginahome()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar la publicación')),
                  );
                }
              } else if (value == 'editar') {
                // Agregar la lógica para editar aquí
              } else if (value == 'vermas') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(mostrar.rtitulo),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Categoría: ${mostrar.rcategoria}'),
                            Text('Descripción: ${mostrar.rdescripcion}'),
                            Text('Clasificación: ${mostrar.clasificacion}'),
                            Text('Compañía: ${mostrar.compania}'),
                            Text('Director: ${mostrar.director}'),
                            Text('Distribuidor: ${mostrar.distribuidor}'),
                            Text('Duración: ${mostrar.duracion}'),
                            Text('Fecha de Estreno: ${mostrar.fechaEstreno}'),
                            Text('Género: ${mostrar.rgenero}'),
                            Text('Guionista: ${mostrar.guionista}'),
                            Text('Idioma: ${mostrar.idioma}'),
                            Text('Productor: ${mostrar.productor}'),
                          ],
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
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) {
              if (uidUsuarioActual == ruid) {
                return <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'eliminar',
                    child: Text('Eliminar'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'editar',
                    child: Text('Editar'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'vermas',
                    child: Text('Ver más'),
                  ),
                ];
              } else {
                return <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'vermas',
                    child: Text('Ver más'),
                  ),
                ];
              }
            },
          ),
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
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Color.fromARGB(255, 255, 0, 0),
              ),
              onRatingUpdate: (rating) {
                currentRating = rating;
                actualizarRating(pubId, rating);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calificación actualizada: $rating')),
                );
              },
            ),
            Text(mostrar.promedioResenas.toStringAsFixed(1)),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    mostrarModalComentarios(
                        context, pubId, comentarioController, urlString);
                  },
                  icon: const Icon(Icons.comment),
                ),
                IconButton(
                  onPressed: () {
                    guardarPublicacion(context, ruid, pubId, uidUsuarioActual);
                  },
                  icon: const Icon(Icons.bookmark),
                ),
                IconButton(
                  onPressed: () {
                    compartirPublicacion(
                        context, ruid, pubId, uidUsuarioActual);
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
