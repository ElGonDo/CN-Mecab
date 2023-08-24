// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, annotate_overrides

import 'package:flutter/material.dart';

class Guardados extends StatelessWidget {
  const Guardados({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Center(
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'CN',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' MECAB',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 10, 10, 10),
      body: ListView(
        children: <Widget>[
          // Agrega aquí los widgets que deseas mostrar en la pantalla de inicio
          Container(
            height: 300,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Contenido 1',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          Container(
            height: 200,
            color: Colors.orange,
            child: Center(
              child: Text(
                'Contenido 2',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          Container(
            height: 200,
            color: Colors.purple,
            child: Center(
              child: Text(
                'Contenido 3',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          Container(
            height: 200,
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                'Contenido 3',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          Container(
            height: 200,
            color: Colors.black87,
            child: Center(
              child: Text(
                'Contenido 3',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          Container(
            height: 200,
            color: Colors.amber,
            child: Center(
              child: Text(
                'Contenido 3',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          // Agrega más contenedores para mostrar más contenido
        ],
      ),
    );
  }
}
