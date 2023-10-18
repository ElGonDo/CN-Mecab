// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cnmecab/modules/profile/pages/objetoUsuario.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  UserProfile? userProfile;
  DateTime? _birthDate;
  DateTime? _creationDate;
  bool isEditing = false;
  bool _isDataLoaded = false;
  List<String> categoriasSeleccionadas = [];
  List<String> tipoPromotoraSeleccionadas = [];
  List<String> tipoCreadorSeleccionado = [];
  List<bool> categoriasCheckbox = [];
  List<bool> tipoPromotoraCheckbox = [];
  List<bool> tipoCreadorCheckbox = [];
  static const List<String> categoriasDisponibles = [
    'Películas',
    'Series',
    'Libros',
    'Animación',
    'Animes',
  ];
  static const List<String> tipoPromotora = [
    'Productora',
    'Animadora',
    'Televisora',
    'Editorial',
  ];
  static const List<String> tiposCreador = [
    'Actor',
    'Actriz',
    'Autor',
    'Mangaka',
  ];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  //final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _creationDateController = TextEditingController();
  //final TextEditingController _typeController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeUserProfile();
  }

  Future<void> initializeUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(user.uid)
            .get();
        Map<String, dynamic> userData =
            userProfileSnapshot.data() as Map<String, dynamic>;

        userProfile = UserProfile(
          uid: user.uid,
          role: userData['Rol'],
        );

        if (!_isDataLoaded) {
          await _fetchUserData();
          setState(() {
            _isDataLoaded = true;
          });
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<void> _fetchUserData() async {
    try {
      if (userProfile?.role == 'Creador') {
        DocumentSnapshot creatorSnapshot = await FirebaseFirestore.instance
            .collection('Creadores')
            .doc(userProfile?.uid)
            .get();
        Map<String, dynamic> creatorData =
            creatorSnapshot.data() as Map<String, dynamic>;

        _nameController.text = creatorData['Nombre_Creador'];
        _birthDate = creatorData['Fecha_Nacimiento'].toDate();
        _birthDateController.text = _birthDate != null
            ? DateFormat('yyyy-MM-dd').format(_birthDate!)
            : '';
        // obtener los creadores seleccionados
        List<dynamic> tipoCreador = creatorData['Tipo Creador'];
        tipoCreadorSeleccionado = tipoCreador.cast<String>();
        // Inicializar las listas de checkboxes
        tipoCreadorCheckbox = List.filled(tiposCreador.length, false);
        // Marcar El Tipo De Creador seleccionado como true
        for (var i = 0; i < tiposCreador.length; i++) {
          if (tipoCreadorSeleccionado.contains(tiposCreador[i])) {
            tipoCreadorCheckbox[i] = true;
          }
        }
      } else if (userProfile?.role == 'Promotora') {
        DocumentSnapshot promoterSnapshot = await FirebaseFirestore.instance
            .collection('Promotoras')
            .doc(userProfile?.uid)
            .get();
        Map<String, dynamic> promoterData =
            promoterSnapshot.data() as Map<String, dynamic>;

        _nameController.text = promoterData['Nombre_Promotora'];
        _creationDate = promoterData['Creacion_Promotora'].toDate();
        _creationDateController.text = _creationDate != null
            ? DateFormat('yyyy-MM-dd').format(_creationDate!)
            : '';
        // Obtener categorías seleccionadas
        List<dynamic> categorias = promoterData['Categoria'];
        categoriasSeleccionadas = categorias.cast<String>();
        // Obtener tipos de promotora seleccionados
        List<dynamic> tiposPromotora = promoterData['Tipo_Promotora'];
        tipoPromotoraSeleccionadas = tiposPromotora.cast<String>();
        // Inicializar las listas de checkboxes
        categoriasCheckbox =
            List<bool>.filled(categoriasDisponibles.length, false);
        tipoPromotoraCheckbox = List<bool>.filled(tipoPromotora.length, false);
        // Marcar las categorías seleccionadas como true
        for (var i = 0; i < categoriasDisponibles.length; i++) {
          if (categoriasSeleccionadas.contains(categoriasDisponibles[i])) {
            categoriasCheckbox[i] = true;
          }
        }
        // Marcar los tipos de promotora seleccionados como true
        for (var i = 0; i < tipoPromotora.length; i++) {
          if (tipoPromotoraSeleccionadas.contains(tipoPromotora[i])) {
            tipoPromotoraCheckbox[i] = true;
          }
        }
      } else if (userProfile?.role == 'Visitante') {
        DocumentSnapshot visitorSnapshot = await FirebaseFirestore.instance
            .collection('Visitantes')
            .doc(userProfile?.uid)
            .get();
        Map<String, dynamic> visitorData =
            visitorSnapshot.data() as Map<String, dynamic>;

        _nameController.text = visitorData['Nombre'];
        _lastNameController.text = visitorData['Apellido'];
        _nicknameController.text = visitorData['Apodo'];
        _birthDate = visitorData['Fecha_Nacimiento'].toDate();
        _birthDateController.text = _birthDate != null
            ? DateFormat('yyyy-MM-dd').format(_birthDate!)
            : '';
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void guardarVisitante(
      String nombre, String apellido, String apodo, DateTime fechaNacimiento) {
    final CollectionReference visitantesCollection =
        FirebaseFirestore.instance.collection('Visitantes');
    visitantesCollection.doc(userProfile?.uid).set({
      'Nombre': nombre,
      'Apellido': apellido,
      'Apodo': apodo,
      'Fecha_Nacimiento': Timestamp.fromDate(fechaNacimiento),
    }).then((value) {
      print('Datos del visitante guardados en Firestore');
    }).catchError((error) {
      print('Error al guardar los datos del visitante: $error');
    });
  }

// Función para guardar los datos del creador en Firestore
  void guardarCreador(String nombreCreador, DateTime fechaNacimiento,
      List<String> tiposCreador) {
    try {
      // Eliminar los tipos de creador deseleccionados
      tipoCreadorSeleccionado
          .removeWhere((tipo) => !tiposCreador.contains(tipo));
      // Guardar los datos actualizados en la base de datos
      final CollectionReference creadoresCollection =
          FirebaseFirestore.instance.collection('Creadores');

      creadoresCollection.doc(userProfile?.uid).set({
        'Nombre_Creador': nombreCreador,
        'Fecha_Nacimiento': Timestamp.fromDate(fechaNacimiento),
        'Tipo Creador': tipoCreadorSeleccionado, // Usar la lista actualizada
      }).then((value) {
        print('Datos del creador guardados en Firestore');
      }).catchError((error) {
        print('Error al guardar los datos del creador: $error');
      });
    } catch (e) {
      // Manejar cualquier error
      print(e.toString());
    }
  }

// Función para guardar los datos de la promotora en Firestore
  void guardarPromotora(String nombrePromotora, DateTime fechaCreacion,
      List<String> categoriasDisponibles, List<String> tipoPromotora) {
    try {
      // Eliminar las categorias deseleccionados
      categoriasSeleccionadas
          .removeWhere((tipo) => !categoriasDisponibles.contains(tipo));
      // Eliminar los tipos de promotora deseleccionados
      tipoPromotoraSeleccionadas
          .removeWhere((tipo) => !tipoPromotora.contains(tipo));
      // Guardar los datos actualizados en la base de datos
      final CollectionReference promotorasCollection =
          FirebaseFirestore.instance.collection('Promotoras');

      promotorasCollection.doc(userProfile?.uid).set({
        'Nombre_Promotora': nombrePromotora,
        'Creacion_Promotora': Timestamp.fromDate(fechaCreacion),
        'Categoria': categoriasSeleccionadas,
        'Tipo_Promotora': tipoPromotoraSeleccionadas,
      }).then((value) {
        print('Datos de la promotora guardados en Firestore');
      }).catchError((error) {
        print('Error al guardar los datos de la promotora: $error');
      });
    } catch (e) {
      // Manejar cualquier error
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cargando perfil')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
          IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                DateTime? newDate;
                newDate = _birthDate;
                if (userProfile?.role == 'Visitante') {
                  _birthDateController.text =
                      DateFormat('yyyy-MM-dd').format(newDate!);
                  guardarVisitante(
                    _nameController.text,
                    _lastNameController.text,
                    _nicknameController.text,
                    newDate,
                  );
                  setState(() {
                    isEditing = !isEditing;
                  });
                } else if (userProfile?.role == 'Creador') {
                  _birthDateController.text =
                      DateFormat('yyyy-MM-dd').format(newDate!);
                  tipoCreadorSeleccionado.clear();
                  for (int i = 0; i < tipoCreadorCheckbox.length; i++) {
                    if (tipoCreadorCheckbox[i]) {
                      tipoCreadorSeleccionado.add(tiposCreador[i]);
                    }
                  }
                  guardarCreador(
                    _nameController.text,
                    newDate,
                    tipoCreadorSeleccionado,
                  );
                  setState(() {
                    isEditing = !isEditing;
                  });
                } else if (userProfile?.role == 'Promotora') {
                  newDate = _creationDate;
                  _creationDateController.text =
                      DateFormat('yyyy-MM-dd').format(newDate!);
                  categoriasSeleccionadas.clear();
                  for (int i = 0; i < categoriasCheckbox.length; i++) {
                    if (categoriasCheckbox[i]) {
                      categoriasSeleccionadas.add(categoriasDisponibles[i]);
                    }
                  }
                  tipoPromotoraSeleccionadas.clear();
                  for (int i = 0; i < tipoPromotoraCheckbox.length; i++) {
                    if (tipoPromotoraCheckbox[i]) {
                      tipoPromotoraSeleccionadas.add(tipoPromotora[i]);
                    }
                  }
                  guardarPromotora(
                    _nameController.text,
                    newDate,
                    categoriasSeleccionadas,
                    tipoPromotoraSeleccionadas,
                  );
                  setState(() {
                    isEditing = !isEditing;
                  });
                }
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                enabled: isEditing,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              if (userProfile?.role == 'Creador') ...[
                TextField(
                  controller: _birthDateController,
                  enabled: isEditing,
                  decoration:
                      const InputDecoration(labelText: 'Fecha de Nacimiento'),
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: _birthDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (newDate != null) {
                      setState(() {
                        _birthDate = newDate;
                        _birthDateController.text =
                            DateFormat('yyyy-MM-dd').format(newDate);
                      });
                    }
                  },
                ),
                const ListTile(
                  title: Text('Tipo Creador'),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tiposCreador.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                      enabled: isEditing,
                      title: Text(tiposCreador[index]),
                      value: tipoCreadorCheckbox[index],
                      onChanged: (bool? value) {
                        setState(() {
                          tipoCreadorCheckbox[index] = value!;
                        });
                      },
                    );
                  },
                ),
              ] else if (userProfile?.role == 'Promotora') ...[
                TextField(
                  controller: _creationDateController,
                  enabled:
                      isEditing, // Habilitar cuando se toque el botón de edición
                  decoration: const InputDecoration(
                      labelText: 'Fecha de Creación de Promotora'),
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: _birthDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (newDate != null) {
                      setState(() {
                        _creationDate = newDate;
                        _creationDateController.text =
                            DateFormat('yyyy-MM-dd').format(newDate);
                      });
                    }
                  },
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const ListTile(
                        title: Text('Categorías'),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoriasDisponibles.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                            enabled: isEditing,
                            title: Text(categoriasDisponibles[index]),
                            value: categoriasCheckbox[index],
                            onChanged: (bool? value) {
                              setState(() {
                                categoriasCheckbox[index] = value!;
                              });
                            },
                          );
                        },
                      ),
                      const ListTile(
                        title: Text('Tipo Promotora'),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tipoPromotora.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                            enabled: isEditing,
                            title: Text(tipoPromotora[index]),
                            value: tipoPromotoraCheckbox[index],
                            onChanged: (bool? value) {
                              setState(() {
                                tipoPromotoraCheckbox[index] = value!;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                )
              ] else if (userProfile?.role == 'Visitante') ...[
                TextField(
                  controller: _lastNameController,
                  enabled:
                      isEditing, // Habilitar cuando se toque el botón de edición
                  decoration: const InputDecoration(labelText: 'Apellido'),
                ),
                TextField(
                  controller: _nicknameController,
                  enabled:
                      isEditing, // Habilitar cuando se toque el botón de edición
                  decoration: const InputDecoration(labelText: 'Apodo'),
                ),
                TextField(
                  controller: _birthDateController,
                  enabled: isEditing,
                  decoration:
                      const InputDecoration(labelText: 'Fecha de Nacimiento'),
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: _birthDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (newDate != null) {
                      setState(() {
                        _birthDate = newDate;
                        _birthDateController.text =
                            DateFormat('yyyy-MM-dd').format(newDate);
                      });
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
