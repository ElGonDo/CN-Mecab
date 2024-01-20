
 // ignore_for_file: unused_import, unnecessary_null_comparison, prefer_const_constructors, use_key_in_widget_constructors
 
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

void mostrarModalComentarios(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ComentariosModal(); // Implementa esta clase según tus necesidades
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
                  mostrarModalComentarios(context); // Llama a la función para mostrar el modal de comentarios
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
class ComentariosModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage('https://via.placeholder.com/180'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Escribe un comentario...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para subir el comentario
                    // Agrega tu lógica aquí para manejar el comentario
                    // Por ejemplo, puedes enviar el comentario a Firebase
                  },
                  child: Text('Comentar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}