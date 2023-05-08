import 'package:flutter/material.dart';

class Guardados extends StatelessWidget {
  const Guardados({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('CN MECAB'),
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 10, 10, 10),
      body: ListView(
        children: <Widget>[
          // Agrega aquí los widgets que deseas mostrar en la pantalla de inicio
          Container(
            height: 200,
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
