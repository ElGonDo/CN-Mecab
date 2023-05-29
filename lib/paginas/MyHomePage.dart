import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedCategory = "";

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'CN',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' MECAB',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () {
              // Acción para mostrar el perfil
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                'Nombre de Usuario',
                style: TextStyle(color: Colors.black),
              ),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text('Cuenta', style: TextStyle(color: Colors.black)),
              onTap: () {},
            ),
            ListTile(
              title:
                  Text('Cambiar Tema', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Acción para mostrar las políticas de seguridad
              },
            ),
            ListTile(
              title: Text('Políticas de Seguridad',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                // Acción para mostrar las políticas de seguridad
              },
            ),
            ListTile(
              title:
                  Text('Cerrar Sesión', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Acción para cerrar sesión
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre de la publicación',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Descripción de la publicación',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Género:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  label: Text('Acción'),
                  selected: _selectedCategory == 'Acción',
                  onSelected: (selected) {
                    _onCategorySelected('Acción');
                  },
                ),
                ChoiceChip(
                  label: Text('Comedia'),
                  selected: _selectedCategory == 'Comedia',
                  onSelected: (selected) {
                    _onCategorySelected('Comedia');
                  },
                ),
                ChoiceChip(
                  label: Text('Drama'),
                  selected: _selectedCategory == 'Drama',
                  onSelected: (selected) {
                    _onCategorySelected('Drama');
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Cargar Imagen'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
