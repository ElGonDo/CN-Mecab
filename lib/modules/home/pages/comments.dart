// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void mostrarModalComentarios(BuildContext context, String pubId,
    TextEditingController comentarioController) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return ComentariosModal(
          pubId: pubId, comentarioController: comentarioController);
    },
  );  
}

Future<void> agregarComentario(String pubId, String comentario) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final comentariosDocumentReference =
        FirebaseFirestore.instance.collection('Comentarios').doc(pubId);
    final comentariosDocument = await comentariosDocumentReference.get();

    if (!comentariosDocument.exists) {
      await comentariosDocumentReference.set({
        'comentarios': {
          user.uid: [comentario]
        }
      });
    } else {
      comentariosDocumentReference.update({
        'comentarios.${user.uid}': FieldValue.arrayUnion([comentario])
      });
    }
  }
}

Future<String?> obtenerNombreUsuario(String uid) async {
  try {
    // Obtener el documento del usuario
    DocumentSnapshot userDocument =
        await FirebaseFirestore.instance.collection('Usuarios').doc(uid).get();

    // Verificar si el documento existe y si contiene datos
    if (userDocument.exists && userDocument.data() != null) {
      // Obtener el nombre del usuario
      String? nombre =
          (userDocument.data() as Map<String, dynamic>?)?['Nombre'];

      return nombre;
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

class ComentariosModal extends StatelessWidget {
  final String pubId;
  final TextEditingController comentarioController;

  const ComentariosModal(
      {required this.pubId, required this.comentarioController});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
                IconButton(
                  onPressed: () async {
                    String comentario = comentarioController.text;
                    if (comentario.trim().isNotEmpty) {
                      await agregarComentario(pubId, comentarioController.text);
                      comentarioController.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('El comentario se ha subido correctamente'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('El comentario no puede estar vacío'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.send),
                  color: Color.fromARGB(255, 243, 33, 33),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24.0,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/180'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: comentarioController,
                      decoration: InputDecoration(
                        hintText: 'Escribe un comentario...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            // Envolver la lista de comentarios en un SizedBox
            height: MediaQuery.of(context).size.height *
                0.5, // Establecer una altura máxima para la lista de comentarios
            child: FutureBuilder<List<Map<String, String>>>(
              future: obtenerComentarios(pubId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No hay comentarios');
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<String?>(
                        future:
                            obtenerNombreUsuario(snapshot.data![index]['uid']!),
                        builder: (context, nombreSnapshot) {
                          if (nombreSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (nombreSnapshot.hasError) {
                            return Text('Error: ${nombreSnapshot.error}');
                          } else {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 20.0,
                                backgroundImage: NetworkImage(
                                    'https://via.placeholder.com/180'),
                              ),
                              title: Text(nombreSnapshot.data ??
                                  'Nombre del Usuario'), // Mostrar el nombre del usuario
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data![index]['comentario']!),
                                  if (snapshot.data![index]['replyTo'] !=
                                      null) // Verificar si es una respuesta
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Respuesta a: ${snapshot.data![index]['replyTo']}',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Obtener el nombre del usuario al que se está respondiendo
                                      String? nombreUsuario =
                                          nombreSnapshot.data ?? 'Usuario';
                                      // Construir el texto de respuesta con el nombre
                                      String textoRespuesta =
                                          'respuesta a: @$nombreUsuario ';
                                      // Añadir el texto de respuesta al principio del cuadro de texto
                                      comentarioController.text =
                                          textoRespuesta +
                                              comentarioController.text;
                                      // Mover el cursor al final del texto
                                      comentarioController.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: comentarioController
                                                      .text.length));
                                    },
                                    icon: Icon(Icons.comment),
                                    color: Color.fromARGB(255, 243, 33, 33),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<Map<String, String>>> obtenerComentarios(String pubId) async {
  List<Map<String, String>> comentarios = [];

  // Obtener el documento de comentarios
  DocumentSnapshot comentariosDocument = await FirebaseFirestore.instance
      .collection('Comentarios')
      .doc(pubId)
      .get();

  // Verificar si el documento existe y si contiene datos
  if (comentariosDocument.exists && comentariosDocument.data() != null) {
    // Obtener el mapa de comentarios
    Map<String, dynamic> data =
        comentariosDocument.data() as Map<String, dynamic>;

    // Obtener el campo 'comentarios' que contiene las matrices de comentarios de diferentes usuarios
    Map<String, dynamic> comentariosMap = data['comentarios'];

    // Iterar sobre todas las matrices de comentarios
    comentariosMap.forEach((uid, comentariosList) {
      // Verificar si el valor es una lista
      if (comentariosList is List<dynamic>) {
        // Iterar sobre cada comentario
        comentariosList.forEach((comentario) {
          comentarios.add({
            'uid': uid, // Agregar el UID del usuario que realizó el comentario
            'comentario': comentario.toString(), // Agregar el comentario
          });
        });
      }
    });
  }
  return comentarios;
}

Widget buildComentariosListWidget(List<Map<String, String>> comentarios) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: comentarios.length,
    itemBuilder: (context, index) {
      String comentario = comentarios[index]['comentario']!;
      String nombreUsuario =
          comentarios[index]['nombre'] ?? 'Nombre del Usuario';
      return ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundImage: NetworkImage('https://via.placeholder.com/180'),
        ),
        title: Text(nombreUsuario),
        subtitle: Text(comentario),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                // Acción al presionar el botón de responder comentario
              },
              icon: Icon(Icons.comment),
              color: Color.fromARGB(255, 243, 33, 33),
            ),
            IconButton(
              onPressed: () {
                // Acción al presionar el botón de reaccionar comentario
              },
              icon: Icon(Icons.thumb_up),
              color: Color.fromARGB(255, 243, 33, 33),
            ),
          ],
        ),
      );
    },
  );
}
