// ignore_for_file: file_names

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'authServiceTest.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late MockFirebaseAuth mockAuth;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      fakeFirestore = FakeFirebaseFirestore();
      authService = AuthService(auth: mockAuth, firestore: fakeFirestore);
    });

    test('register with valid email and password', () async {
      final userCredential = await authService.register(
        'test@example.com',
        'password123',
        'userRole',
      );

      expect(userCredential, isNotNull);
      expect(userCredential!.user!.email, 'test@example.com');

      final userData = await fakeFirestore
          .collection('Usuarios')
          .doc(userCredential.user!.uid)
          .get();
      expect(userData['Rol'], 'userRole');
      expect(userData['Fecha_Registro'], isNotNull);
    });

    test('login with valid email and password', () async {
      await mockAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      final userCredential = await authService.login(
        'test@example.com',
        'password123',
      );

      expect(userCredential, isNotNull);
      expect(userCredential!.user!.email, 'test@example.com');
    });
  });
}
