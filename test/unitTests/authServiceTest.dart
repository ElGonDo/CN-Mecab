// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserCredential?> register(
      String email, String password, String selectedRole) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore
          .collection('Usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'Rol': selectedRole,
        'Fecha_Registro': DateTime.now(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Manejo de errores específicos de FirebaseAuth
      throw AuthException(
        code: e.code, // Use 'unknown' si e.code es nulo
        message: e.message ?? 'Ocurrió un error durante el registro',
      );
    } catch (e) {
      // Manejo de otros errores
      throw AuthException(message: 'Ocurrió un error: $e', code: '');
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Manejo de errores específicos de FirebaseAuth
      throw AuthException(
        code: e.code,
        message: e.message ?? 'Ocurrió un error durante el inicio de sesión',
      );
    } catch (e) {
      // Manejo de otros errores
      throw AuthException(message: 'Ocurrió un error: $e', code: '');
    }
  }
}

class AuthException implements Exception {
  final String code;
  final String message;

  AuthException({required this.code, required this.message});
}
