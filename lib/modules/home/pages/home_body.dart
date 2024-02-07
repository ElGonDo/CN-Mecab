
 // ignore_for_file: unused_import, unnecessary_null_comparison, prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously
 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnmecab/modules/Post_show/show_post_Resenables.dart';
import 'package:cnmecab/modules/home/pages/comments.dart';
import 'package:cnmecab/modules/home/pages/filter_body.dart';
import 'package:cnmecab/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
void actualizarRating(String pubId, double rating) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Obtener la referencia del documento en la colección de Reseñas
    final reseniasDocumentReference = FirebaseFirestore.instance.collection('Reseñas').doc(pubId);
    final reseniasDocument = await reseniasDocumentReference.get();
    Map<String, dynamic> reseniasData;
    if (!reseniasDocument.exists) {
      // Si el documento no existe, inicializamos el mapa con la calificación actual y la ID del usuario
      reseniasData = {
        'calificaciones': {
          user.uid: rating,
        }
      };
    } else {
      // Si el documento ya existe, obtenemos los datos actuales del documento
      reseniasData = reseniasDocument.data() as Map<String, dynamic>;
      // Actualizamos el mapa con la calificación actual del usuario
      reseniasData['calificaciones'][user.uid] = rating;
    }

    // Calcular el promedio de las calificaciones
    double sumaCalificaciones = reseniasData['calificaciones'].values.reduce((value, element) => value + element);
    int cantidadCalificaciones = reseniasData['calificaciones'].length;
    double promedioCalificaciones = sumaCalificaciones / cantidadCalificaciones;

    // Actualizamos el mapa con el promedio de las calificaciones
    reseniasData['promedio'] = promedioCalificaciones;

    // Actualizamos el documento en la base de datos
    await reseniasDocumentReference.set(reseniasData, SetOptions(merge: true));
  } else {
    // Si el usuario no está autenticado, muestra un mensaje o toma otra acción según tus necesidades
    print('El usuario no está autenticado.');
  }
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
                    return buildCardWidget2(titulo, descripcion, pubId, '$pubId.jpg');
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
              color: Color.fromARGB(255, 0, 0, 0),
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

Widget buildCardWidget2(String title, String description, String pubId, String imageName,) {
  double currentRating = 3.0; // Calificación inicial

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
              color: Color.fromARGB(255, 0, 0, 0),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea los íconos al final de la fila
          children: [
            RatingBar.builder(
              initialRating: currentRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20.0, // Tamaño del ícono de la calificación
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Color.fromARGB(255, 255, 0, 0),
              ),
              onRatingUpdate: (rating) {
                currentRating = rating;
                actualizarRating(pubId, rating); // Llama a la función para actualizar el rating
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calificación actualizada: $rating')),
                );
              },
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Aquí puedes agregar la lógica para comentarios
                  },
                  icon: Icon(Icons.comment),
                ),
                IconButton(
                  onPressed: () {
                    // Aquí puedes agregar la lógica para guardar
                  },
                  icon: Icon(Icons.bookmark),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
}

