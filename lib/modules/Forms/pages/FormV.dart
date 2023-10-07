// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, file_names, unused_field, constant_identifier_names, non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FormVPage extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();

  FormVPage({super.key});

  @override
  _FormVPageState createState() => _FormVPageState();
}

class _FormVPageState extends State<FormVPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _apodoController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedImage;
  final String _Image =
      'https://firebasestorage.googleapis.com/v0/b/cn-mecab-3c43c.appspot.com/o/profileV%2FFirefly%20perfil%20de%20avatar%2029892.jpg?alt=media&token=0df68c4e-9dea-4b00-a22e-99bfc0fb1699&_gl=1*11v9o81*_ga*MTI3OTQzOTQ0LjE2OTQyODQ2MDU.*_ga_CW55HF8NVT*MTY5NjYzNjYxNy4xOS4xLjE2OTY2NDQ0NDEuNTIuMC4w';
  final String _Image2 =
      'https://firebasestorage.googleapis.com/v0/b/cn-mecab-3c43c.appspot.com/o/profileV%2FFirefly%20perfil%20de%20avatar%2035512.jpg?alt=media&token=e66af79f-0d3b-487a-84c5-5a211bf905b4&_gl=1*1gy3b9g*_ga*MTI3OTQzOTQ0LjE2OTQyODQ2MDU.*_ga_CW55HF8NVT*MTY5NjYzNjYxNy4xOS4xLjE2OTY2NDQyODQuMTMuMC4w';
  void _submitForm() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Convertir la fecha seleccionada a un valor de tipo Timestamp
        final birthDateTimestamp =
            _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null;

        // Guardar los datos en la colección "Visitantes" de Firestore
        await FirebaseFirestore.instance
            .collection('Visitantes')
            .doc(currentUser.uid)
            .set({
          'Nombre': _nombreController.text,
          'Apellido': _apellidoController.text,
          'Apodo': _apodoController.text,
          'Fecha_Nacimiento': birthDateTimestamp,
          'Foto_Pefil_URL': _selectedImage,
          'Rol': 'Visitante'
        });

        // Actualizar los datos del usuario en la colección "Usuarios"
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(currentUser.uid)
            .update({
          'Activo': true,
        });

        // Mostrar mensaje de éxito y regresar a la página de inicio
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Éxito'),
              content: const Text('Los datos se guardaron correctamente.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/home');
                  },
                  child: const Text('¡Continuar!'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectImage1Fuction() {
    setState(() {
      _selectedImage = _Image;
    });
  }

  void _selectImage2Funtion() {
    setState(() {
      _selectedImage = _Image2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Align(
          alignment: Alignment.center,
          child: Text('Formulario Visitante'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apellidoController,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su apellido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apodoController,
                  decoration: const InputDecoration(labelText: 'Apodo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su apellido';
                    }
                    return null;
                  },
                ),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fecha de nacimiento',
                    ),
                    child: Text(
                      _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : 'Seleccione una fecha',
                    ),
                  ),
                ),
                const Text(
                  'Seleccione Su Avatar:',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: _selectImage1Fuction,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedImage == _Image
                                ? Colors.blue
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Image.network(
                          _Image,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _selectImage2Funtion,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedImage == _Image2
                                ? Colors.blue
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Image.network(
                          _Image2,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
