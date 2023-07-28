// ignore_for_file: depend_on_referenced_packages, unused_import

import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nombre de tu App',
      theme: appTheme,
      onGenerateRoute: generateRoute,
      initialRoute: '/login',
    );
  }
}
