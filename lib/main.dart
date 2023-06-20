import 'package:cnmecab/paginas/Busqueda.dart';
import 'package:cnmecab/paginas/PaginaHome.dart';
import 'package:cnmecab/paginas/MyHomePage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _paginaActual = 0;

  List<Widget> _paginas = [
    Paginahome(),
    MyHomePage(),
    Busqueda(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _paginas[_paginaActual],
        bottomNavigationBar: Theme(
          data: ThemeData(
            canvasColor: Colors.black, // Fondo negro del menú
          ),
          child: BottomNavigationBar(
            onTap: (index) {
              if (index == 3) {
                // Lógica para manejar la acción de "Guardados"
              } else {
                setState(() {
                  _paginaActual = index;
                });
              }
            },
            currentIndex: _paginaActual,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.file_upload_outlined), label: "Agregar"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search_outlined), label: "Buscar"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.save_outlined), label: "Guardados"),
            ],
          ),
        ),
      ),
    );
  }
}
