// ignore_for_file: file_names
import 'package:flutter/material.dart';

class FilterProfileSearch extends StatelessWidget {
  final String role;
  final String currentPage;
  final Function(String) onPageChanged;
  final BuildContext context;

  const FilterProfileSearch({
    super.key,
    required this.role,
    required this.onPageChanged,
    required this.currentPage,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    List<String> visitorSections = ['Sus Compartidos'];
    List<String> creatorSections = ['Sus Compartidos', 'Sus Publicaciones'];
    List<String> sections =
        role == 'Visitante' ? visitorSections : creatorSections;

    return LayoutBuilder(
      builder: (context, constraints) {
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
                  width: constraints.maxWidth / sections.length,
                  color:
                      currentPage == section ? Colors.blue : Colors.transparent,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      section,
                      style: TextStyle(
                        fontSize: 14,
                        color: currentPage == section
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
