import 'package:cnmecab/paginas/Guardados.dart';
import 'package:cnmecab/paginas/PaginaHome.dart';
import 'package:cnmecab/paginas/PaginaUsers.dart';
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
    PaginaUsers(),
    Guardados(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _paginas[_paginaActual],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _paginaActual = index;
            });
          },
          currentIndex: _paginaActual,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
            BottomNavigationBarItem(
                icon: Icon(Icons.file_upload_outlined), label: "Agregar"),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined), label: "Buscar"),
          ],
        ),
      ),
    );
  }
}
