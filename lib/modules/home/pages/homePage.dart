// ignore_for_file: unnecessary_import, implementation_imports, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, file_names, use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_print, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnmecab/modules/auth/services/authChangeEmail.dart';
import 'package:cnmecab/modules/auth/services/authRequest.dart';
import 'package:cnmecab/modules/home/pages/homeBody.dart';
import 'package:cnmecab/modules/notifications/pages/notifications.dart';
import 'package:cnmecab/modules/profile/services/objectUser.dart';
import 'package:cnmecab/modules/publications/postPublications/pages/postPublications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Paginahome extends StatefulWidget {
  const Paginahome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaginahomeState createState() => _PaginahomeState();
}

class _PaginahomeState extends State<Paginahome> {
  Future<bool> cambiaContrasena(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController newpasswordController = TextEditingController();
    final user = auth.currentUser!;

    try {
      var result = await showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: Text('Cambiar contraseña: '),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Contraseña actual'),
                obscureText: true,
                controller: passwordController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Nueva contraseña'),
                obscureText: true,
                onChanged: (String? newValue) {
                  setState(() {
                    newpasswordController.text = newValue ?? '';
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            BasicDialogAction(
              title: Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            BasicDialogAction(
              title: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        ),
      );

      if (result == true) {
        String newPassword = newpasswordController.text;
        String currentPassword = passwordController.text;

        try {
          final credentials = EmailAuthProvider.credential(
            email: user.email!,
            password: currentPassword,
          );
          await user.reauthenticateWithCredential(credentials);
          await user.updatePassword(newPassword);
          Fluttertoast.showToast(msg: 'Contraseña actualizada exitosamente');
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacementNamed('/welcome');
          return true;
        } catch (error) {
          //print('Error al actualizar la contraseña: $error');
          Fluttertoast.showToast(msg: 'Error al actualizar la contraseña');
        }
      }

      return false;
    } catch (error) {
      //print('Error durante el cambio de contraseña: $error');
      return false;
    }
  }

  UserProfile? userProfile;
  @override
  void initState() {
    super.initState();
    // Llamamos al método para inicializar el perfil del usuario
    UserProfileSingleton().initializeUserProfile().then((profile) {
      setState(() {
        userProfile = profile;
      });
    });
  }

  String currentPage = 'Para ti';
  bool isDarkModeEnabled = false;
  int navegador = 0;
  final List<Widget> _paginas = [
    BodyPage(),
    Publicar(),
    Notificacion(),
  ];
  final List<Widget> _paginas2 = [
    BodyPage(),
    Notificacion(),
  ];
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
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' MECAB',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 19,
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
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/Search');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/ProfileNew');
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
                '¡Hola! ${userProfile?.name}',
                style:
                    TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
              ),
              accountEmail: null,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text('Cuenta', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.of(context).pushNamed('/ProfileNew');
              },
            ),
            ListTile(
              title: Text('Terminos y Políticas de Seguridad',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Cn Mecab',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      'Ag System Information ${DateTime.now().year} Cn Mecab',
                  //applicationIcon:
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/politics');
                      },
                      child: const Text('Politicas de Privacidad'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/terms');
                      },
                      child: const Text('Terminos y condiciones'),
                    ),
                  ],
                );
              },
            ),
            ListTile(
              title:
                  Text('Cerrar Sesión', style: TextStyle(color: Colors.black)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/welcome');
              },
            ),
            ListTile(
              title:
                  Text('Borrar Cuenta', style: TextStyle(color: Colors.black)),
              onTap: () async {
                // Invocar al método para solicitar autenticación nuevamente
                bool success = await solicitarAutenticacion(context);

                if (success) {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  await FirebaseFirestore.instance
                      .collection('Usuarios')
                      .doc(currentUser?.uid)
                      .update({
                    'Activo': false,
                  });
                  // Si la autenticación es exitosa, eliminar la cuenta y actualizar
                  await FirebaseAuth.instance.currentUser!.delete();
                  Navigator.of(context).pushReplacementNamed('/welcome');
                } else {
                  // Si la autenticación no es exitosa, realizar alguna acción adicional o mostrar un mensaje de error al usuario
                }
              },
            ),
            ListTile(
              title:
                  Text('Cambiar Correo', style: TextStyle(color: Colors.black)),
              onTap: () async {
                bool cambioExitoso = await cambiarCorreo(context);
                // Realiza las acciones necesarias dependiendo si el cambio fue exitoso o no
                if (cambioExitoso) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Cambio Exitoso'),
                        content: Text(
                            'El cambio de correo fue realizado correctamente.'),
                        actions: [
                          TextButton(
                            child: Text('Aceptar'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text(
                            'Hubo un error al cambiar el correo. Por favor, inténtalo nuevamente.'),
                        actions: [
                          TextButton(
                            child: Text('Aceptar'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            ListTile(
              title: Text('Cambiar Contraseña',
                  style: TextStyle(color: Colors.black)),
              onTap: () async {
                bool cambioExitoso = await cambiaContrasena(context);
                // Realiza las acciones necesarias dependiendo si el cambio fue exitoso o no
                if (cambioExitoso) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Cambio Exitoso'),
                        content: Text(
                            'El cambio de contraseña fue realizado correctamente.'),
                        actions: [
                          TextButton(
                            child: Text('Aceptar'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text(
                            'Hubo un error al cambiar la contraseña Por favor, inténtalo nuevamente.'),
                        actions: [
                          TextButton(
                            child: Text('Aceptar'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: (userProfile != null && userProfile?.role != 'Visitante')
          ? _paginas[navegador]
          : _paginas2[navegador],
      bottomNavigationBar: SalomonBottomBar(
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        backgroundColor: Colors.black,
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        onTap: (index) {
          setState(() {
            navegador = index;
          });
        },
        currentIndex: navegador,
        items: [
          SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("home"),
              selectedColor: Color.fromARGB(255, 156, 37, 37)),
          if (userProfile != null && userProfile?.role != 'Visitante')
            SalomonBottomBarItem(
                icon: Icon(Icons.file_upload_outlined),
                title: Text("Subir Publicaciones"),
                selectedColor: Color.fromARGB(255, 156, 37, 37)),
          SalomonBottomBarItem(
              icon: Icon(Icons.notifications),
              title: Text("Notificaciones"),
              selectedColor: Color.fromARGB(255, 156, 37, 37)),
        ],
      ),
    );
  }
}
