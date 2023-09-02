// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FormCPage extends StatefulWidget {
  const FormCPage({super.key});

  @override
  _FormCPageState createState() => _FormCPageState();
}

class _FormCPageState extends State<FormCPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedTipoRole;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Convertir la fecha seleccionada a un valor de tipo Timestamp
        final birthDateTimestamp =
            _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null;

        // Guardar los datos en la colección "Creadores" de Firestore
        await FirebaseFirestore.instance
            .collection('Creadores')
            .doc(currentUser.uid)
            .set({
          'Nombre_Creador': _nombreController.text,
          'Fecha_Nacimiento': birthDateTimestamp,
          'Tipo Creador': _selectedTipoRole,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text('Formulario Creador'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre Completo De Creador'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese Su Nombre Completo';
                    }
                    return null;
                  },
                ),
                DropdownButton<String>(
                  value: _selectedTipoRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTipoRole = newValue;
                    });
                  },
                  items: <String>['Actor', 'Actriz', 'Autor', 'Mangaka']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: const Text('Selecciona Un Tipo De Creador'),
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
                const SizedBox(height: 20),
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
