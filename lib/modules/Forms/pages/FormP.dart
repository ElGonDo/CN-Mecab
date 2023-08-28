// ignore_for_file: library_private_types_in_public_api, file_names, unused_local_variable, use_build_context_synchronously, unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FormPPage extends StatefulWidget {
  const FormPPage({super.key});

  @override
  _FormPPageState createState() => _FormPPageState();
}

class _FormPPageState extends State<FormPPage> {
  final _formKey = GlobalKey<FormState>();
  List<String> categoriasSeleccionadas = [];
  List<String> tiposSeleccionados = [];

  String nombrePromotora = '';
  DateTime? fechaCreacionPromotora;

  void guardarDatos() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = FirebaseAuth.instance.currentUser;
      _formKey.currentState?.save();
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('Promotoras')
            .doc(currentUser.uid)
            .set({
          'Nombre_Promotora': nombrePromotora,
          'Creacion_Promotora': fechaCreacionPromotora,
          'Categoria': categoriasSeleccionadas,
          'Tipo_Promotora': tiposSeleccionados,
        });

        // Actualizar los datos del usuario en la colección "Usuarios"
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(currentUser.uid)
            .update({
          'Activo': true,
        });
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
        fechaCreacionPromotora = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: Alignment.center,
          child: Text('Formulario Promotora'),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
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
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre Completo de la Promotora'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingresa el nombre de la promotora';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    nombrePromotora = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fecha de Creacion De La Promotora',
                    ),
                    child: Text(
                      fechaCreacionPromotora != null
                          ? DateFormat('yyyy-MM-dd')
                              .format(fechaCreacionPromotora!)
                          : 'Seleccione una fecha',
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Categorías',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CheckboxListTile(
                  title: const Text('Películas'),
                  value: categoriasSeleccionadas.contains('Películas'),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        categoriasSeleccionadas.add('Películas');
                      } else {
                        categoriasSeleccionadas.remove('Películas');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Series'),
                  value: categoriasSeleccionadas.contains('Series'),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        categoriasSeleccionadas.add('Series');
                      } else {
                        categoriasSeleccionadas.remove('Series');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Libros'),
                  value: categoriasSeleccionadas.contains('Libros'),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        categoriasSeleccionadas.add('Libros');
                      } else {
                        categoriasSeleccionadas.remove('Libros');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Animación'),
                  value: categoriasSeleccionadas.contains('Animación'),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        categoriasSeleccionadas.add('Animación');
                      } else {
                        categoriasSeleccionadas.remove('Animación');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Animes'),
                  value: categoriasSeleccionadas.contains('Animes'),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        categoriasSeleccionadas.add('Animes');
                      } else {
                        categoriasSeleccionadas.remove('Animes');
                      }
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Tipo de Promotora',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CheckboxListTile(
                  title: const Text('Productora'),
                  value: tiposSeleccionados.contains('Productora'),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        tiposSeleccionados.add('Productora');
                      } else {
                        tiposSeleccionados.remove('Productora');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Animadora'),
                  value: tiposSeleccionados.contains('Animadora'),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        tiposSeleccionados.add('Animadora');
                      } else {
                        tiposSeleccionados.remove('Animadora');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Televisora'),
                  value: tiposSeleccionados.contains('Televisora'),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        tiposSeleccionados.add('Televisora');
                      } else {
                        tiposSeleccionados.remove('Televisora');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Editorial'),
                  value: tiposSeleccionados.contains('Editorial'),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        tiposSeleccionados.add('Editorial');
                      } else {
                        tiposSeleccionados.remove('Editorial');
                      }
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: guardarDatos,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
