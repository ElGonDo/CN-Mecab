import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<String> _categories = [
    "Para Ti",
    "Películas",
    "Series",
    "Libros",
    "Animes"
  ];

  List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Text(
        'Para Ti',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
    Center(
      child: Text(
        'Películas',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
    Center(
      child: Text(
        'Series',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
    Center(
      child: Text(
        'Libros',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
    Center(
      child: Text(
        'Animes',
        style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CN MECAB',
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Menú',
                style: TextStyle(fontSize: 20),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Cerrar Sesión'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Cuenta'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Más'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                          color: _selectedIndex == index
                              ? Colors.blue
                              : Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
