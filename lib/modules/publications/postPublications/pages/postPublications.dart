import 'dart:io';
import 'package:cnmecab/modules/publications/postPublications/selectImage.dart';
import 'package:cnmecab/modules/publications/postPublications/services/uploadImage.dart';
import 'package:cnmecab/modules/publications/postPublications/services/firebase_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Publicar extends StatefulWidget {
  const Publicar({Key? key});

  @override
  State<Publicar> createState() => _PublicarState();
}

class _PublicarState extends State<Publicar> {
  TextEditingController tituloController = TextEditingController(text: "");
  TextEditingController descripcionController = TextEditingController(text: "");
  TextEditingController directorController = TextEditingController(text: "");
  TextEditingController productorController = TextEditingController(text: "");
  TextEditingController guionistaController = TextEditingController(text: "");
  TextEditingController distriController = TextEditingController(text: "");
  TextEditingController companiaController = TextEditingController(text: "");
  TextEditingController clasificacionController =
      TextEditingController(text: "");
  TextEditingController idiomaController = TextEditingController(text: "");
  TextEditingController fechaEstrenoController =
      TextEditingController(text: "");
  TextEditingController duracionController = TextEditingController(text: "");

  // ignore: non_constant_identifier_names
  File? image_to_upload;
  final List<String> _selectedGeneros = [];
  String? _selectedCategory;
  String? _tipoPubli;
  List<String> categoriasSeleccionadas = [];
  String? collectionName;

  final List<String> generosPeliculas = [
    'Acción',
    'Aventuras',
    'Ciencia Ficción',
    'Comedia',
    'No-Ficción / Documental',
    'Drama',
    'Fantasía',
    'Musical',
    'Suspense',
    'Terror',
  ];

  final List<String> generosCineFormato = [
    'Cinema sonoro',
    'Cine 2D',
    'Películas 3D',
    'Animación',
  ];

  final List<String> generosAmbientacion = [
    'Religiosas',
    'Futuristas',
    'Policíacas',
    'Crimen',
    'Bélicas',
    'Históricas',
    'Deportivas',
    'Western',
  ];

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onTypePubli(String? tipoPubli) {
    setState(() {
      _tipoPubli = tipoPubli;
    });
    if (tipoPubli == 'Reseñable') {
      collectionName = "Publicaciones_Reseñables";
    } else if (tipoPubli == 'No reseñable') {
      collectionName = "Publicaciones_No_Reseñables";
    } else {
      return;
    }
  }

  void _onGeneroSelected(String? genero) {
    setState(() {
      if (_selectedGeneros.contains(genero)) {
        _selectedGeneros.remove(genero);
      } else {
        _selectedGeneros.add(genero!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initializeUserId();
  }

  Future<void> initializeUserId() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;
        if (kDebugMode) {
          print('El UID del usuario es: $uid');
        }
      } else {
        if (kDebugMode) {
          print('No hay usuario autenticado.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
    }
  }

  Future<void> enviarANotificaciones(
      String titulo, String descripcion, String category, String userId) async {
    try {
      // Obtener la referencia a la colección de notificaciones
      CollectionReference notificacionesRef =
          FirebaseFirestore.instance.collection('Notificaciones');

      // Obtener el nombre del usuario que crea la publicación
      User? user = FirebaseAuth.instance.currentUser;
      String nombreUsuario = user?.displayName ?? 'Usuario Desconocido';

      // Crear un documento para la notificación
      await notificacionesRef.add({
        'titulo': titulo,
        'descripcion': descripcion,
        'categoria': category,
        'nombreUsuario': nombreUsuario,
        'userId':
            userId, // Si es necesario, puedes almacenar también el ID de usuario
        'timestamp': FieldValue
            .serverTimestamp(), // Marcar la fecha y hora de la notificación
      });

      // Éxito al enviar la notificación
      // ignore: avoid_print
      print('Notificación enviada correctamente');
    } catch (error) {
      // Manejar cualquier error que ocurra durante el envío de la notificación
      // ignore: avoid_print
      print('Error al enviar la notificación: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Titulo Publicación:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: 'Titulo de la publicación',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Descripción de la Publicación:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción de la publicación',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Director:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: directorController,
              decoration: const InputDecoration(
                labelText: 'Director de la película',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Productor:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: productorController,
              decoration: const InputDecoration(
                labelText: 'Productor de la película',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Guionista:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: guionistaController,
              decoration: const InputDecoration(
                labelText: 'Guionista de la película',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Distribuidor:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: distriController,
              decoration: const InputDecoration(
                labelText: 'Distribuidor de la película',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Compañía de producción:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: companiaController,
              decoration: const InputDecoration(
                labelText: 'Compañía de producción de la película',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Clasificación:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: clasificacionController,
              decoration: const InputDecoration(
                labelText: 'Clasificación de la película',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Idioma original:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: idiomaController,
              decoration: const InputDecoration(
                labelText: 'Idioma original de la película',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Fecha de estreno (cines):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: fechaEstrenoController,
              decoration: InputDecoration(
                labelText: 'Fecha de estreno (cines):',
                suffixIcon: InkWell(
                  onTap: () async {
                    final DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        fechaEstrenoController.text =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                      });
                    }
                  },
                  child: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Duración:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: duracionController,
              decoration: const InputDecoration(
                labelText: 'Duración de la película (en minutos)',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Categoría de tu publicación',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: ['Películas', 'Series', 'Libros', 'Animes']
                  .map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                _onCategorySelected(newValue);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Seleccionar Géneros"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...generosPeliculas.map((genero) {
                              return CheckboxListTile(
                                title: Text(genero),
                                value: _selectedGeneros.contains(genero),
                                onChanged: (bool? value) {
                                  _onGeneroSelected(genero);
                                },
                              );
                            }).toList(),
                            ...generosCineFormato.map((genero) {
                              return CheckboxListTile(
                                title: Text(genero),
                                value: _selectedGeneros.contains(genero),
                                onChanged: (bool? value) {
                                  _onGeneroSelected(genero);
                                },
                              );
                            }).toList(),
                            ...generosAmbientacion.map((genero) {
                              return CheckboxListTile(
                                title: Text(genero),
                                value: _selectedGeneros.contains(genero),
                                onChanged: (bool? value) {
                                  _onGeneroSelected(genero);
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          child: const Text("Cerrar"),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: const Text("Seleccionar Géneros"),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tipo de publicación:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  label: const Text('Reseñable'),
                  selected: _tipoPubli == 'Reseñable',
                  onSelected: (selected) {
                    _onTypePubli('Reseñable');
                  },
                ),
                ChoiceChip(
                  label: const Text('No reseñable'),
                  selected: _tipoPubli == 'No reseñable',
                  onSelected: (selected) {
                    _onTypePubli('No reseñable');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            image_to_upload != null
                ? Image.file(image_to_upload!)
                : Container(
                    margin: const EdgeInsets.all(10),
                    height: 200,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 151, 151, 151),
                  ),
            ElevatedButton(
                onPressed: () async {
                  final XFile? imagen = await getImage();
                  setState(() {
                    image_to_upload = File(imagen!.path);
                  });
                },
                child: const Text("Seleccionar imagen")),
            ElevatedButton(
                onPressed: () async {
                  final postId = await addTitle(
                      tituloController.text,
                      descripcionController.text,
                      directorController.text,
                      productorController.text,
                      guionistaController.text,
                      distriController.text,
                      companiaController.text,
                      clasificacionController.text,
                      idiomaController.text,
                      fechaEstrenoController.text,
                      duracionController.text,
                      _selectedCategory ?? '',
                      _selectedGeneros.join(', '),
                      collectionName ?? '');
                  if (image_to_upload == null) {
                    return;
                  }
                  final uploaded = await uploadImage(image_to_upload!, postId);

                  if (uploaded) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Error al subir la imagen")));
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Imagen subida correctamente")));
                  }

                  // Envía los datos a la colección de Notificaciones
                  await enviarANotificaciones(
                      tituloController.text,
                      descripcionController.text,
                      _selectedCategory ?? '',
                      FirebaseAuth.instance.currentUser?.uid ?? '');
                },
                child: const Text("Subir Publicacion y Notificar"))
          ],
        ),
      ),
    );
  }
}
