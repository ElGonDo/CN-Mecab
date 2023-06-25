import 'package:flutter/material.dart';

class BarraMenu extends StatelessWidget {
  final int paginaActual;
  final ValueChanged<int> onPageChanged;

  BarraMenu({
    required this.paginaActual,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.black, // Fondo negro del menú
      ),
      child: BottomNavigationBar(
        onTap: onPageChanged,
        currentIndex: paginaActual,
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
    );
  }
}
