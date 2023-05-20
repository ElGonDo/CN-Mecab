import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';

class Paginahome extends StatefulWidget {
  @override
  _PaginahomeState createState() => _PaginahomeState();
}

class _PaginahomeState extends State<Paginahome> {
  String currentPage = 'Para ti';

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
          Icon(
            Icons.account_circle,
            color: Colors.white,
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
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ListTile(
              title:
                  Text('Cerrar Sesión', style: TextStyle(color: Colors.black)),
              onTap: () {},
            ),
            ListTile(
              title: Text('Cuenta', style: TextStyle(color: Colors.black)),
              onTap: () {},
            ),
            ListTile(
              title: Text('Más', style: TextStyle(color: Colors.black)),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 'Para ti';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        currentPage == 'Para ti' ? Colors.red : Colors.white,
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Para ti',
                    style: TextStyle(
                      fontSize: 15,
                      color: currentPage == 'Para ti'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 'Películas';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        currentPage == 'Películas' ? Colors.red : Colors.white,
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Películas',
                    style: TextStyle(
                      fontSize: 15,
                      color: currentPage == 'Películas'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 'Series';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        currentPage == 'Series' ? Colors.red : Colors.white,
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Series',
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          currentPage == 'Series' ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 'Libros';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        currentPage == 'Libros' ? Colors.red : Colors.white,
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Libros',
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          currentPage == 'Libros' ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 'Animes';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        currentPage == 'Animes' ? Colors.red : Colors.white,
                    minimumSize: Size(199, 50),
                    maximumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Animes',
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          currentPage == 'Animes' ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                if (currentPage == 'Para ti') {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                          ),
                          title: Text('Universal Studio'),
                          subtitle: Text('Presentamos Rapidos y Furiosos X'),
                        ),
                        Image.network('https://via.placeholder.com/350'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.thumb_up),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.comment),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.share),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Card(
                    child: Center(
                      child: Text(
                        'Página de $currentPage',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
