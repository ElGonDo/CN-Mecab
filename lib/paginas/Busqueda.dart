import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';

class Busqueda extends StatefulWidget {
  @override
  _BusquedaState createState() => _BusquedaState();
}

class _BusquedaState extends State<Busqueda> {
  String searchQuery = '';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Buscar',
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Realizar la búsqueda con searchQuery
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Aquí puedes mostrar los resultados de búsqueda
          ListTile(
            title: Text('Resultado 1'),
          ),
          ListTile(
            title: Text('Resultado 2'),
          ),
          ListTile(
            title: Text('Resultado 3'),
          ),
        ],
      ),
    );
  }
}
