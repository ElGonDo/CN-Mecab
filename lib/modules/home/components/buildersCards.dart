// ignore_for_file: file_names

import 'package:cnmecab/modules/profile/filterProfileServicesSaved.dart';
import 'package:cnmecab/modules/profile/filterProfileServicesShared.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsNoResenables.dart';
import 'package:cnmecab/modules/home/components/comments.dart';
import 'package:cnmecab/modules/home/pages/home_body.dart';
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
  String title,
  String description,
  String pubId,
  String imageName,
  String ruid,
  BuildContext context,
  String uidUsuarioActual,
  TextEditingController comentarioController,
  String urlString,
) {
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
                  SnackBar(content: Text('Calificación actualizada: $rating')),
                );
              },
            ),
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
