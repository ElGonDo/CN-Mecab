import 'package:cnmecab/modules/auth/pages/loginPage.dart';
import 'package:cnmecab/modules/home/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Método de inicialización de Firebase
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Login test', (WidgetTester tester) async {
    // Construir la aplicación con rutas configuradas
    await tester.pumpWidget(
      MaterialApp(
        home: const LoginPage(),
        routes: {
          '/home': (context) =>
              const Paginahome(), // Define la ruta a la página de inicio
        },
      ),
    );

    // Encuentra el campo de correo electrónico y contraseña y completa los datos
    final Finder emailField = find.byKey(const Key('emailField'));
    final Finder passwordField = find.descendant(
      of: find.byKey(const Key('passwordField2')),
      matching: find.byType(TextFormField),
    );
    final Finder loginButton = find.byKey(const Key('loginButton'));

    await tester.tap(emailField);
    await tester.enterText(emailField, 'jimenesdavid377@gmail.com');

    await tester.tap(passwordField);
    await tester.enterText(passwordField, 'Holamama.2');

    // Toca el botón de inicio de sesión
    await tester.tap(loginButton);

    // Espera 2 segundos para la autenticación y redirección
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verifica que la pantalla actual es la página de inicio buscando un widget específico de la página de inicio
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
