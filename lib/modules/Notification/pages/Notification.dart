import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            notificaciones = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notificaciones.length,
              itemBuilder: (context, index) {
                var notificacion = notificaciones[index];
                if (notificacionesOcultas.contains(notificacion)) {
                  return SizedBox.shrink(); // Ocultar la notificación
                }
                String titulo = notificacion['titulo'];
                String descripcion = notificacion['descripcion'];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Nueva publicación - $titulo'),
                    subtitle: Text(descripcion),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          notificacionesOcultas.add(notificacion);
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
