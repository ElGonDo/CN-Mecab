// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void mostrarModalComentarios(BuildContext context, String pubId, TextEditingController comentarioController) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return ComentariosModal(pubId: pubId, comentarioController: comentarioController);
    },
  );
}

Future<void> agregarComentario(String pubId, String comentario) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final comentariosDocumentReference = FirebaseFirestore.instance.collection('Comentarios').doc(pubId);
    final comentariosDocument = await comentariosDocumentReference.get();

    if (!comentariosDocument.exists) {
      await comentariosDocumentReference.set({
        'comentarios': {user.uid: [comentario]}
      });
    } else {
      comentariosDocumentReference.update({
        'comentarios.${user.uid}': FieldValue.arrayUnion([comentario])
      });
    }
  }
}

class ComentariosModal extends StatelessWidget {
  final String pubId;
  final TextEditingController comentarioController;

  const ComentariosModal({required this.pubId, required this.comentarioController});
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
                          content: Text('El comentario se ha subido correctamente'),
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
                  backgroundImage: NetworkImage('https://via.placeholder.com/180'),
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
          SizedBox( // Envolver la lista de comentarios en un SizedBox
            height: MediaQuery.of(context).size.height * 0.5, // Establecer una altura máxima para la lista de comentarios
            child: FutureBuilder<List<String>>(
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
                      String comentario = snapshot.data![index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage('https://via.placeholder.com/180'),
                        ),
                        title: Text('Nombre del Usuario'), // Puedes reemplazar esto con el nombre del usuario real si lo tienes
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
  Future<List<String>> obtenerComentarios(String pubId) async {
  List<String> comentarios = [];

  // Obtener el documento de comentarios
  DocumentSnapshot comentariosDocument = await FirebaseFirestore.instance.collection('Comentarios').doc(pubId).get();

  // Verificar si el documento existe y si contiene datos
  if (comentariosDocument.exists && comentariosDocument.data() != null) {
    // Obtener el mapa de comentarios
    Map<String, dynamic> data = comentariosDocument.data() as Map<String, dynamic>;

    // Obtener el campo 'comentarios' que contiene las matrices de comentarios de diferentes usuarios
    Map<String, dynamic> comentariosMap = data['comentarios'];

    // Iterar sobre todas las matrices de comentarios
    comentariosMap.forEach((key, value) {
      // Verificar si el valor es una lista
      if (value is List<dynamic>) {
        // Agregar todos los comentarios de esta matriz a la lista de comentarios
        value.forEach((comentario) {
          comentarios.add(comentario.toString());
        });
      }
    });
  }
  return comentarios;
}

  Widget buildComentariosListWidget(List<String> comentarios) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: comentarios.length,
      itemBuilder: (context, index) {
        String comentario = comentarios[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage('https://via.placeholder.com/180'),
          ),
          title: Text('Nombre del Usuario'), // Puedes reemplazar esto con el nombre del usuario real si lo tienes
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
