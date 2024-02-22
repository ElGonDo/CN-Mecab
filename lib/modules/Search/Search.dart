// ignore_for_file: use_key_in_widget_constructors, file_names, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  const Search({Key? key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  List<String> collections = ['Visitantes', 'Promotoras', 'Creadores'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: searchController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              hintText: 'Busqueda',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.black),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildSearchResult(context, 'Visitantes'),
          _buildDivider(),
          _buildSearchResult(context, 'Promotoras'),
          _buildDivider(),
          _buildSearchResult(context, 'Creadores'),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 20,
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(vertical: 10),
    );
  }

  Widget _buildSearchResult(BuildContext context, String collection) {
    String field1;
    if (collection == 'Visitantes') {
      field1 = 'Apodo';
    } else if (collection == 'Promotoras') {
      field1 = 'Nombre_Promotora';
    } else {
      field1 = 'Nombre_Creador';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(collection)
              .where(
                field1,
                isGreaterThanOrEqualTo: searchController.text,
                isLessThan: searchController.text + 'z',
              )
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("No se encontró nada");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 56,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                String title = doc[field1] ?? '';
                return GestureDetector(
                  onTap: () {
                    _showPopup(context);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(title),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Popup de prueba'),
          content: const Text('Este es un mensaje de prueba'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
