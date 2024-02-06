
 // ignore_for_file: unused_import, unnecessary_null_comparison, prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously
 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnmecab/modules/Post_show/show_post_Resenables.dart';
import 'package:cnmecab/modules/home/pages/filter_body.dart';
import 'package:cnmecab/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
//import 'package:cnmecab/services/firebase_services.dart';
import 'package:flutter/material.dart';
// Importa la clase FilterBody
import 'package:cnmecab/modules/Post_show/show_posts_No_Resenables.dart';

class BodyPage extends StatefulWidget {
  const BodyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaginahomeState createState() => _PaginahomeState();
}

class _PaginahomeState extends State<BodyPage> {
  String currentPage = 'Para ti';
  bool isDarkModeEnabled = false;
  List<Publicacion> publicacionesList = [];
  List<PublicacionR> publicacionesListR = [];
  TextEditingController comentarioController = TextEditingController(text: "");
   @override
  void initState() {
    super.initState();
    obtenerDatos((data) {
      setState(() {
        publicacionesList = data;
      });
    });
    obtenerDatosR((data) {
      setState(() {
        publicacionesListR = data;
      });
    });
  }

void actualizarLikes(String pubId) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Obtén la referencia del documento en la colección de Reacciones
    final reaccionesDocumentReference = db.collection('Reacciones').doc(pubId);
    final reaccionesDocument = await reaccionesDocumentReference.get();
    Map<String, dynamic> reaccionesData;
    if (!reaccionesDocument.exists) {
      reaccionesData = {};
    } else {
      reaccionesData = reaccionesDocument.data() as Map<String, dynamic>;
    }

    // Asegúrate de que reaccionesData y pubId no sean nulos
    if (reaccionesData != null && pubId != null) {
      // Obtén el número actual de likes o establece 0 si no existe
      int likes = reaccionesData['likes'] ?? 0;

      // Obtén la lista actual de usuarios que dieron like o establece una lista vacía si no existe
      List<dynamic> usuariosQueDieronLikeDynamic = reaccionesData['usuarios_que_dieron_like'] ?? [];
      
      // Convierte la lista de dinámica a una lista de cadenas
      List<String> usuariosQueDieronLike = usuariosQueDieronLikeDynamic.cast<String>();

      // Verifica si el usuario ya dio like
      if (!usuariosQueDieronLike.contains(user.uid)) {
        // Incrementa el contador de likes
        likes++;

        // Agrega la UID del usuario a la lista
        usuariosQueDieronLike.add(user.uid);

        // Actualiza los datos en la base de datos
        reaccionesData = {
          'likes': likes,
          'usuarios_que_dieron_like': usuariosQueDieronLike,
        };

        await reaccionesDocumentReference.set(reaccionesData, SetOptions(merge: true));
      }
    }
  }
}

void mostrarModalComentarios(BuildContext context, String pubId, TextEditingController comentarioController) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return ComentariosModal(pubId: pubId, comentarioController: comentarioController);
    },
  );
}
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20.0),
          FilterBody(
            currentPage: currentPage,
            onPageChanged: (newPage) {
              setState(() {
                currentPage = newPage;
              });
            },
          ),
          const SizedBox(height: 20.0),
         Expanded(
  child: ListView.builder(
    itemCount: currentPage == 'Para ti' ? publicacionesList.length + publicacionesListR.length : publicacionesListR.length,
    itemBuilder: (context, index) {
      // Agrega aquí el contenido específico para cada página
 if (currentPage == 'Para ti') {
        if (index < publicacionesList.length) {
          // Esto es para mostrar el contenido de publicacionesList
          String titulo = publicacionesList[index].titulo;
          String descripcion = publicacionesList[index].descripcion;
          String pubId = publicacionesList[index].pubID;
                    return buildCardWidget(titulo, descripcion, pubId, '$pubId.jpg');
                  } else {
          // Esto es para mostrar el contenido de publicacionesListR
           int rIndex = index - publicacionesList.length;
                    String rtitulo = publicacionesListR[rIndex].rtitulo;
                    String rdescripcion = publicacionesListR[rIndex].rdescripcion;
                    String pubId = publicacionesListR[rIndex].rpubID;
                    return buildCardWidget(rtitulo, rdescripcion, pubId, '$pubId.jpg');
                  }
                
        
      } else if (currentPage == 'Películas') {
                  // Código para la página de películas
                  String rtitulo = publicacionesListR[index].rtitulo;
                  String rdescripcion = publicacionesListR[index].rdescripcion;
                  String pubId = publicacionesListR[index].rpubID;
                  return buildCardWidget(rtitulo, rdescripcion, pubId, '$pubId.jpg');
                } else if (currentPage == 'Series') {
                  // Código para la página de series
                  String rtitulo = publicacionesListR[index].rtitulo;
                  String rdescripcion = publicacionesListR[index].rdescripcion;
                  String pubId = publicacionesListR[index].rpubID;
                  return buildCardWidget(rtitulo, rdescripcion, pubId, '$pubId.jpg');
                } else if (currentPage == 'Libros') {
                  // Código para la página de libros
                  String rtitulo = publicacionesListR[index].rtitulo;
                  String rdescripcion = publicacionesListR[index].rdescripcion;
                  String pubId = publicacionesListR[index].rpubID;
                  return buildCardWidget(rtitulo, rdescripcion, pubId, '$pubId.jpg');
                } else if (currentPage == 'Animes') {
                  // Código para la página de animes
                  String rtitulo = publicacionesListR[index].rtitulo;
                  String rdescripcion = publicacionesListR[index].rdescripcion;
                  String pubId = publicacionesListR[index].rpubID;
                  return buildCardWidget(rtitulo, rdescripcion, pubId, '$pubId.jpg');
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardWidget(String title, String description, String pubId, String imageName) {
  return Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Agregar el Text con la ID del mapa
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'ID de la publicación: $pubId',   
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
          ListTile(
            leading: const CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage('https://via.placeholder.com/180'),
            ),
            title: Text(title),
            subtitle: Text(description),
          ),
           FutureBuilder<String>(
          future: getImageUrl(imageName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtiene la URL de la imagen
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('Error cargando la imagen'); // Muestra un mensaje si hay un error
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
                   // Llama a la función para actualizar el contador de likes
                  actualizarLikes(pubId);
              },
                icon: const Icon(Icons.thumb_up),
              ),
              IconButton(
                onPressed: () {
                 mostrarModalComentarios(context, pubId, comentarioController);// Llama a la función para mostrar el modal de comentarios
               },
                icon: const Icon(Icons.comment),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
Future<void> agregarComentario(String pubId, String comentario) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Obtener la referencia del documento en la colección de Comentarios
    final comentariosDocumentReference = FirebaseFirestore.instance.collection('Comentarios').doc(pubId);
    final comentariosDocument = await comentariosDocumentReference.get();

    if (!comentariosDocument.exists) {
      // Si el documento no existe, crea uno nuevo
      await comentariosDocumentReference.set({
        'comentarios': {user.uid: [comentario]}
      });
    } else {
      // Si el documento existe, agrega el comentario al documento existente
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Botones de cerrar el modal y enviar comentario
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botón de cerrar el modal
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
              // Botón de enviar comentario
              IconButton(
                onPressed: () async {
                  // Obtén el texto del comentario del controlador
                  String comentario = comentarioController.text;
                  // Verifica si el comentario no está vacío
                  if (comentario.trim().isNotEmpty) {
                    // Llama a la función para agregar el comentario
                    await agregarComentario(pubId, comentarioController.text);
                    // Limpia el texto del controlador después de enviar el comentario
                    comentarioController.clear();
                    // Cierra el modal
                    Navigator.pop(context);
                    // Muestra un SnackBar para informar al usuario que el comentario se ha subido correctamente
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('El comentario se ha subido correctamente'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                    // Muestra un SnackBar para informar al usuario que el comentario está vacío
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
        // Foto del usuario y caja de texto
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Foto del usuario
              CircleAvatar(
                radius: 24.0,
                backgroundImage: NetworkImage('https://via.placeholder.com/180'),
              ),
              SizedBox(width: 8),
              // Caja de texto para escribir un nuevo comentario con padding en la parte inferior
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
        // Lista de comentarios
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Comentario de ejemplo
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar del usuario
                    CircleAvatar(
                      radius: 16.0,
                      backgroundImage: NetworkImage('https://via.placeholder.com/180'),
                    ),
                    SizedBox(width: 8),
                    // Comentario del usuario
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Nombre del Usuario',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Este es un comentario de ejemplo. Aquí puedes ver el texto completo del comentario.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    // Botones de responder y reaccionar
                    Column(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}