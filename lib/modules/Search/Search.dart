import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 10,
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search',
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchResult('Promotoras', 'Nombre_Promotora'),
          _buildSearchResult('Creadores', 'Nombre_Creador'),
          _buildSearchResult('Visitantes', 'Apodo'),
          _buildSearchResult('Publicaciones_No_Reseñables', 'Genero','Titulo', 'Descripcion'),
          _buildSearchResult('Publicaciones_Reseñables', 'Titulo', 'Genero', 'Descripcion'),
        ],
      ),
    );
  }

  Widget _buildSearchResult(String collection, String field1, [String? field2, String? field3]) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(collection).where(
          field1,
          isEqualTo: searchController.text,
        ).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("No se encontro nada");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (_, index) {
              final doc = snapshot.data!.docs[index];
              String title = doc[field1];
              if (field2 != null && doc[field2] != null) {
                title += ' ${doc[field2]}';
              }
              if (field3 != null && doc[field3] != null) {
                title += ' ${doc[field3]}';
              }
              return Card(
                child: ListTile(
                  title: Text(title),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
