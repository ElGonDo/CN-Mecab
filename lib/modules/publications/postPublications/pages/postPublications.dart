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
  const Publicar({super.key});

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

  File? imageToUpload;
  final List<String> _selectedGeneros = [];
  String? _selectedCategory;
  String? _tipoPubli;
  List<String> categoriasSeleccionadas = [];
  String? collectionName;
  Map<String, bool> _fieldErrors = {};

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
    'Cinema sonoro',
    'Cine 2D',
    'Películas 3D',
    'Animación',
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
      if (tipoPubli == 'Reseñable') {
        collectionName = "Publicaciones_Reseñables";
      } else if (tipoPubli == 'No reseñable') {
        collectionName = "Publicaciones_No_Reseñables";
      } else {
        return;
      }
    });
  }

  void _onGeneroSelected(String genero, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedGeneros.add(genero);
      } else {
        _selectedGeneros.remove(genero);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tipoPubli = 'Reseñable';
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
      CollectionReference notificacionesRef =
          FirebaseFirestore.instance.collection('Notificaciones');

      User? user = FirebaseAuth.instance.currentUser;
      String nombreUsuario = user?.displayName ?? 'Usuario Desconocido';

      await notificacionesRef.add({
        'titulo': titulo,
        'descripcion': descripcion,
        'categoria': category,
        'nombreUsuario': nombreUsuario,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Notificación enviada correctamente');
    } catch (error) {
      print('Error al enviar la notificación: $error');
    }
  }

  bool _validateFields() {
    _fieldErrors.clear();
    bool isValid = true;

    if (_tipoPubli == null) {
      _fieldErrors['Tipo de publicación'] = true;
      isValid = false;
    }
    if (tituloController.text.isEmpty) {
      _fieldErrors['Título de la publicación'] = true;
      isValid = false;
    }
    if (descripcionController.text.isEmpty) {
      _fieldErrors['Descripción de la publicación'] = true;
      isValid = false;
    }
    if (_selectedCategory == null) {
      _fieldErrors['Categoría de la publicación'] = true;
      isValid = false;
    }
    if (_selectedGeneros.isEmpty) {
      _fieldErrors['Géneros de la publicación'] = true;
      isValid = false;
    }
    if (_tipoPubli == 'Reseñable') {
      if (directorController.text.isEmpty) {
        _fieldErrors['Director de la película'] = true;
        isValid = false;
      }
      if (productorController.text.isEmpty) {
        _fieldErrors['Productor de la película'] = true;
        isValid = false;
      }
      if (guionistaController.text.isEmpty) {
        _fieldErrors['Guionista de la película'] = true;
        isValid = false;
      }
      if (distriController.text.isEmpty) {
        _fieldErrors['Distribuidor de la película'] = true;
        isValid = false;
      }
      if (companiaController.text.isEmpty) {
        _fieldErrors['Compañía de producción de la película'] = true;
        isValid = false;
      }
      if (clasificacionController.text.isEmpty) {
        _fieldErrors['Clasificación de la película'] = true;
        isValid = false;
      }
      if (idiomaController.text.isEmpty) {
        _fieldErrors['Idioma original de la película'] = true;
        isValid = false;
      }
      if (fechaEstrenoController.text.isEmpty) {
        _fieldErrors['Fecha de estreno de la película'] = true;
        isValid = false;
      }
      if (duracionController.text.isEmpty) {
        _fieldErrors['Duración de la película'] = true;
        isValid = false;
      }
    }
    if (imageToUpload == null) {
      _fieldErrors['Imagen de la publicación'] = true;
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String fieldName) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        errorText: _fieldErrors[fieldName] == true
            ? 'Este campo es obligatorio'
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _fieldErrors[fieldName] == true ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
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
            const Text(
              'Título Publicación:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildTextField(tituloController, '', 'Título de la publicación'),
            const SizedBox(height: 20),
            const Text(
              'Descripción de la Publicación:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildTextField(
                descripcionController, '', 'Descripción de la publicación'),
            const SizedBox(height: 20),
            if (_tipoPubli == 'Reseñable') ...[
              const Text(
                'Director:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _buildTextField(
                  directorController, '', 'Director de la película'),
              const SizedBox(height: 20),
              const Text(
                'Productor:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _buildTextField(
                  productorController, '', 'Productor de la película'),
              const SizedBox(height: 20),
              const Text(
                'Guionista:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _buildTextField(
                  guionistaController, '', 'Guionista de la película'),
              const SizedBox(height: 20),
              const Text(
                'Distribuidor:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _buildTextField(
                  distriController, '', 'Distribuidor de la película'),
              const SizedBox(height: 20),
              const Text(
                'Compañía de producción:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _buildTextField(companiaController, '',
                  'Compañía de producción de la película'),
              const SizedBox(height: 20),
              const Text(
                'Clasificación:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _buildTextField(
                  clasificacionController, '', 'Clasificación de la película'),
              const SizedBox(height: 20),
              const Text(
                'Idioma original:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _buildTextField(
                  idiomaController, '', 'Idioma original de la película'),
              const SizedBox(height: 20),
              const Text(
                'Fecha de estreno (cines):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: fechaEstrenoController,
                decoration: InputDecoration(
                  labelText: 'Fecha de estreno (cines):',
                  errorText:
                      _fieldErrors['Fecha de estreno de la película'] == true
                          ? 'Este campo es obligatorio'
                          : null,
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
              _buildTextField(duracionController, '',
                  'Duración de la película (en minutos)'),
            ],
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
              decoration: InputDecoration(
                errorText: _fieldErrors['Categoría de la publicación'] == true
                    ? 'Este campo es obligatorio'
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text("Seleccionar Géneros"),
                          content: SingleChildScrollView(
                            child: Column(
                              children: generosPeliculas.map((genero) {
                                final isSelected =
                                    _selectedGeneros.contains(genero);
                                return CheckboxListTile(
                                  title: Text(genero),
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _onGeneroSelected(genero, value!);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                              ),
                              child: const Text("Cerrar"),
                            ),
                          ],
                        );
                      },
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
            imageToUpload != null
                ? Image.file(imageToUpload!)
                : Container(
                    margin: const EdgeInsets.all(10),
                    height: 200,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 151, 151, 151),
                    child: const Center(
                      child: Text(
                        "No hay imagen seleccionada",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
            ElevatedButton(
              onPressed: () async {
                final XFile? imagen = await getImage();
                setState(() {
                  imageToUpload = File(imagen!.path);
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: const Text("Seleccionar imagen"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_validateFields()) {
                  _showAlert("Cn Mecab",
                      "Por favor complete todos los campos obligatorios.✋😉");
                  return;
                }

                String postId;
                if (_tipoPubli == 'Reseñable') {
                  postId = await Publicaciones_Resenables(
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
                    _selectedGeneros,
                    collectionName ?? '',
                  );
                } else {
                  postId = await Publicaciones_No_Resenables(
                    tituloController.text,
                    descripcionController.text,
                    _selectedCategory ?? '',
                    _selectedGeneros,
                  );
                }

                final uploaded = await uploadImage(imageToUpload!, postId);

                if (!uploaded) {
                  _showAlert("Éxito", "Imagen subida correctamente.");
                  return;
                } else {
                  _showAlert("Error", "Error al subir la imagen..");
                }

                await enviarANotificaciones(
                  tituloController.text,
                  descripcionController.text,
                  _selectedCategory ?? '',
                  FirebaseAuth.instance.currentUser?.uid ?? '',
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: const Text("Subir Publicación"),
            ),
          ],
        ),
      ),
    );
  }
}
