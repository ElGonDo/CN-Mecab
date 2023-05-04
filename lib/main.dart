import 'package:cnmecab/paginas/Guardados.dart';
import 'package:cnmecab/paginas/PaginaHome.dart';
import 'package:cnmecab/paginas/PaginaUsers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';

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
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          title: const Text('CN MECAB'),
        ),
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
