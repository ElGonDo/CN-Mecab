import 'package:flutter/material.dart';

class Paginahome extends StatelessWidget {
  const Paginahome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cargar una Pubilicacion',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 10, 10, 10),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: 200,
            width: double.infinity,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            height: 200,
            width: double.infinity,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ],
      ),
    );
  }
}
