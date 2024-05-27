// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, file_names, unused_field, constant_identifier_names, non_constant_identifier_names
import 'package:cnmecab/modules/profile/services/objectUser.dart';
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
        });

        // Actualizar los datos del usuario en la colección "Usuarios"
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(currentUser.uid)
            .update({
          'Activo': true,
          'Nombre': _nombreController.text,
        });

        UserProfileSingleton().initializeUserProfile(uid: currentUser.uid);

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
                const SizedBox(height: 30),
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
