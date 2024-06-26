// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, file_names, library_private_types_in_public_api, unnecessary_null_comparison, unused_local_variable, avoid_print, prefer_const_constructors

import 'package:cnmecab/modules/auth/components/PasswordField.dart';
import 'package:cnmecab/modules/auth/services/authService.dart';
import 'package:cnmecab/modules/auth/services/validationFunctions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? selectedRole;
  bool emailIsValid = false;
  final formKey = GlobalKey<FormState>();
  final List<String> roles = ['Visitante', 'Creador', 'Promotora'];
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'CN',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' MECAB',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Correo Electrónico',
                    ),
                    controller: emailController,
                    validator: (value) => validateEmail(value!),
                  ),
                  const SizedBox(height: 10),
                  PasswordField(
                    controller: passwordController,
                    labelText: 'Contraseña',
                    validator: (value) => validatePassword(value!),
                  ),
                  const SizedBox(height: 10),
                  PasswordField(
                    controller: confirmpasswordController,
                    labelText: 'Confirmar Contraseña',
                    validator: (value) => validateConfirmPassword(
                      value!,
                      passwordController.text,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    items: roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    },
                    validator: (value) => validateRole(value),
                    hint: const Text('Selecciona Un Rol'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Registrarse'),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final String email = emailController.text;
                        final String password = passwordController.text;
                        if (selectedRole != null) {
                          UserCredential? userCredential =
                              await _authService.register(
                                  email, password, context, selectedRole!);
                          if (userCredential != null) {
                            // Redirigir al usuario según el rol seleccionado
                            switch (selectedRole) {
                              case 'Visitante':
                                Navigator.of(context).pushNamed('/FormV');
                                break;
                              case 'Creador':
                                Navigator.of(context).pushNamed('/FormC');
                                break;
                              case 'Promotora':
                                Navigator.of(context).pushNamed('/FormP');
                                break;
                            }
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
