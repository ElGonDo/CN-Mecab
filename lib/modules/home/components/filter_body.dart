import 'package:flutter/material.dart';

class FilterBody extends StatelessWidget {
  final String currentPage;
  final Function(String) onPageChanged;

  const FilterBody({super.key, 
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 41,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ElevatedButton(
            onPressed: () => onPageChanged('Para ti'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  currentPage == 'Para ti' ? const Color.fromARGB(255, 255, 0, 0) : Colors.white,
              minimumSize: const Size(199, 50),
              maximumSize: const Size(200, 50),
            ),
            child: Text(
              'Para ti',
              style: TextStyle(
                fontSize: 15,
                color: currentPage == 'Para ti' ? Colors.white : Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => onPageChanged('Películas'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  currentPage == 'Películas' ? Colors.red : Colors.white,
              minimumSize: const Size(199, 50),
              maximumSize: const Size(200, 50),
            ),
            child: Text(
              'Películas',
              style: TextStyle(
                fontSize: 15,
                color: currentPage == 'Películas' ? Colors.white : Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => onPageChanged('Series'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  currentPage == 'Series' ? Colors.red : Colors.white,
              minimumSize: const Size(199, 50),
              maximumSize: const Size(200, 50),
            ),
            child: Text(
              'Series',
              style: TextStyle(
                fontSize: 15,
                color: currentPage == 'Series' ? Colors.white : Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => onPageChanged('Libros'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  currentPage == 'Libros' ? Colors.red : Colors.white,
              minimumSize: const Size(199, 50),
              maximumSize: const Size(200, 50),
            ),
            child: Text(
              'Libros',
              style: TextStyle(
                fontSize: 15,
                color: currentPage == 'Libros' ? Colors.white : Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => onPageChanged('Animes'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  currentPage == 'Animes' ? Colors.red : Colors.white,
              minimumSize: const Size(199, 50),
              maximumSize: const Size(200, 50),
            ),
            child: Text(
              'Animes',
              style: TextStyle(
                fontSize: 15,
                color: currentPage == 'Animes' ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}