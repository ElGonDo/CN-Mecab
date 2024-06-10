// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class FilterStars extends StatelessWidget {
  final Function(int) onFilterSelected;

  const FilterStars({Key? key, required this.onFilterSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtrar por estrellas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () {
                        onFilterSelected(i);
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 40,
                          ),
                          Text('$i estrella${i > 1 ? 's' : ''}'),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
