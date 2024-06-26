// ignore_for_file: file_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cnmecab/modules/auth/services/authService.dart';

void main() {
  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
  });

  group('AuthService Tests', () {
    late AuthService authService;
    late MockFirebaseAuth mockAuth;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      fakeFirestore = FakeFirebaseFirestore();
      authService = AuthService(auth: mockAuth, firestore: fakeFirestore);
    });

    testWidgets('register with invalid email and password',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              try {
                await authService.register(
                  'invalidemail@example.com',
                  'invalidpassword',
                  context,
                  'userRole',
                );
                // Si no se lanza una excepción, la prueba falla
                fail('Exception not thrown');
              } catch (e) {
                // Verifica que la excepción lanzada sea la esperada
                expect(e, isInstanceOf<Exception>());
              }
            },
            child: const Text('Register with Invalid Email'),
          ),
        ),
      ));

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
    });

    testWidgets('login with invalid email and password',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              try {
                await authService.login(
                  'invalidemail@example.com',
                  'invalidpassword',
                  context,
                );
                // Si no se lanza una excepción, la prueba falla
                fail('Exception not thrown');
              } catch (e) {
                // Verifica que la excepción lanzada sea la esperada
                expect(e, isInstanceOf<Exception>());
              }
            },
            child: const Text('Login with Invalid Email'),
          ),
        ),
      ));

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
    });

    testWidgets('register with valid email and password',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              final result = await authService.register(
                'test@example.com',
                'password123',
                context,
                'userRole',
              );

              expect(result, isNotNull);
              expect(result?.user?.email, 'test@example.com');

              // Simular la recuperación del usuario de Firestore
              final docSnapshot = await fakeFirestore
                  .collection('Usuarios')
                  .doc(result!.user!.uid)
                  .get();
              final userData = docSnapshot.data() as Map<String, dynamic>;

              expect(userData['Rol'], 'userRole');
              expect(userData['Fecha_Registro'], isNotNull);
            },
            child: const Text('Register'),
          ),
        ),
      ));

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
    });

    testWidgets('login with valid email and password',
        (WidgetTester tester) async {
      await mockAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              final result = await authService.login(
                'test@example.com',
                'password123',
                context,
              );

              expect(result, isNotNull);
              expect(result?.user?.email, 'test@example.com');
            },
            child: const Text('Login'),
          ),
        ),
      ));

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
    });
  });
}
