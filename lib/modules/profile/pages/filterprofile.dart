import 'package:flutter/material.dart';

class FilterProfile extends StatelessWidget {
  final String currentPage;
  final String userRole;
  final Function(String) onPageChanged;
  final List<String> visitorSections = ['Mis Guardados', 'Mis Compartidos'];
  final List<String> creatorSections = [
    'Mis Guardados',
    'Mis Compartidos',
    'Mis Publicaciones',
  ];

  FilterProfile({
    Key? key,
    required this.currentPage,
    required this.userRole,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> sections =
        userRole == 'Visitante' ? visitorSections : creatorSections;

    double buttonWidth = MediaQuery.of(context).size.width / sections.length;

    return SizedBox(
      height: 41,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: sections.map((section) {
          return GestureDetector(
            onTap: () {
              onPageChanged(section);
            },
            child: Container(
              width: buttonWidth,
              color: currentPage == section ? Colors.blue : Colors.transparent,
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  section,
                  style: TextStyle(
                    fontSize: 14,
                    color: currentPage == section ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
