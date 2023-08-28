// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UserProfile {
  final String uid;
  final String role; // Agrega un campo para el rol del usuario

  UserProfile({required this.uid, required this.role});
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _userProfile;
  DateTime? _birthDate;
  DateTime? _creationDate;
  bool _isDataLoaded = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _creationDateController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeUserProfile();
  }

  Future<void> _initializeUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(user.uid)
            .get();
        Map<String, dynamic> userData =
            userProfileSnapshot.data() as Map<String, dynamic>;

        _userProfile = UserProfile(
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
      if (_userProfile?.role == 'Creador') {
        DocumentSnapshot creatorSnapshot = await FirebaseFirestore.instance
            .collection('Creadores')
            .doc(_userProfile?.uid)
            .get();
        Map<String, dynamic> creatorData =
            creatorSnapshot.data() as Map<String, dynamic>;

        _nameController.text = creatorData['Nombre_Creador'];
        _birthDate = creatorData['Fecha_Nacimiento'].toDate();
        _birthDateController.text = _birthDate != null
            ? DateFormat('yyyy-MM-dd').format(_birthDate!)
            : '';
        _typeController.text = creatorData['Tipo Creador'];
      } else if (_userProfile?.role == 'Promotora') {
        DocumentSnapshot promoterSnapshot = await FirebaseFirestore.instance
            .collection('Promotoras')
            .doc(_userProfile?.uid)
            .get();
        Map<String, dynamic> promoterData =
            promoterSnapshot.data() as Map<String, dynamic>;

        _nameController.text = promoterData['Nombre_Promotora'];
        _creationDate = promoterData['Creacion_Promotora'].toDate();
        _creationDateController.text = _creationDate != null
            ? DateFormat('yyyy-MM-dd').format(_creationDate!)
            : '';
        _categoryController.text = promoterData['Categoria'].join(', ');
        _typeController.text = promoterData['Tipo_Promotora'].join(', ');
      } else if (_userProfile?.role == 'Visitante') {
        DocumentSnapshot visitorSnapshot = await FirebaseFirestore.instance
            .collection('Visitantes')
            .doc(_userProfile?.uid)
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

  @override
  Widget build(BuildContext context) {
    if (_userProfile == null) {
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              enabled: false,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            if (_userProfile?.role == 'Creador') ...[
              TextField(
                controller: _birthDateController,
                enabled: false,
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
              TextField(
                controller: _typeController,
                enabled: false, // Habilitar cuando se toque el botón de edición
                decoration: const InputDecoration(labelText: 'Tipo de Creador'),
              ),
            ] else if (_userProfile?.role == 'Promotora') ...[
              TextField(
                controller: _creationDateController,
                enabled: false, // Habilitar cuando se toque el botón de edición
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
              TextField(
                controller: _categoryController,
                enabled: false, // Habilitar cuando se toque el botón de edición
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              TextField(
                controller: _typeController,
                enabled: false, // Habilitar cuando se toque el botón de edición
                decoration:
                    const InputDecoration(labelText: 'Tipo de Promotora'),
              ),
            ] else if (_userProfile?.role == 'Visitante') ...[
              TextField(
                controller: _lastNameController,
                enabled: false, // Habilitar cuando se toque el botón de edición
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: _nicknameController,
                enabled: false, // Habilitar cuando se toque el botón de edición
                decoration: const InputDecoration(labelText: 'Apodo'),
              ),
              TextField(
                controller: _birthDateController,
                enabled: false,
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
    );
  }
}
