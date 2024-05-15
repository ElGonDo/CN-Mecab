import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Notificacion extends StatefulWidget {
  const Notificacion({Key? key}) : super(key: key);

  @override
  _NotificacionState createState() => _NotificacionState();
}

class _NotificacionState extends State<Notificacion> {
  List<DocumentSnapshot> notificaciones = [];
  List<DocumentSnapshot> notificacionesOcultas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Notificaciones').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            notificaciones = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notificaciones.length,
              itemBuilder: (context, index) {
                var notificacion = notificaciones[index];
                if (notificacionesOcultas.contains(notificacion)) {
                  return const SizedBox.shrink(); // Ocultar la notificación
                }
                String titulo = notificacion['titulo'];
                String descripcion = notificacion['descripcion'];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Nueva publicación - $titulo'),
                    subtitle: Text(descripcion),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () async {
                        // Ocultar la notificación
                        setState(() {
                          notificacionesOcultas.add(notificacion);
                        });

                        // Obtener el usuario actual
                        User? currentUser = FirebaseAuth.instance.currentUser;

                        // Actualizar la colección de notificaciones para ocultar esta notificación para el usuario actual
                        await FirebaseFirestore.instance
                            .collection('Notificaciones')
                            .doc(notificacion.id)
                            .collection('Ocultas')
                            .doc(currentUser?.uid)
                            .set({
                          'hidden': true,
                        });
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
