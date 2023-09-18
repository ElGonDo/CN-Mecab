import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  QuerySnapshot? _searchResults;

  void _performSearch() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Publicaciones_No_Reseñables');

    QuerySnapshot querySnapshot = await collectionReference
        .where('titulo', isEqualTo: _searchQuery)
        .get();

    setState(() {
      _searchResults = querySnapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar en Firebase'),
        backgroundColor: Colors.black, // Establece el color de fondo en negro
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchQuery = _searchController.text;
                      _performSearch();
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchResults != null
                ? ListView.builder(
                    itemCount: _searchResults!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = _searchResults!.docs[index];
                      // Accede al campo 'titulo' de tu documento
                      String titulo = document['titulo'];
                      return ListTile(
                        title: Text(titulo),
                      );
                    },
                  )
                : const Center(
                    child: Text('No hay resultados'),
                  ),
          ),
        ],
      ),
    );
  }
}
