// ignore_for_file: file_names, prefer_const_constructors
import 'package:cnmecab/modules/home/pages/homeBody.dart';
import 'package:flutter/material.dart';

void showPopupProfileDataSearch(
    BuildContext context, String name, String role, String uid) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Perfil de $name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center, // Centrar la imagen horizontalmente
              child: FutureBuilder<NetworkImage?>(
                future: obtenerImagenUrlUsuarios(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return const CircleAvatar(
                      radius: 50.0, // Aumentar el tamaño del círculo
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/180'),
                    );
                  } else {
                    return CircleAvatar(
                      radius: 50.0, // Aumentar el tamaño del círculo
                      backgroundImage: snapshot.data!,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(role),
          ],
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
