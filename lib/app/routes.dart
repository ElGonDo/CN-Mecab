// ignore_for_file: unused_import, prefer_const_constructors

import 'package:cnmecab/modules/Home/pages/home_page.dart';
import 'package:cnmecab/modules/Home/pages/my_home_page.dart';
import 'package:cnmecab/modules/Login/pages/login_page.dart';
import 'package:cnmecab/modules/Register/pages/register_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => MyHomePage());
    case '/home':
      return MaterialPageRoute(builder: (_) => Paginahome());
    case '/login':
      return MaterialPageRoute(builder: (_) => LoginPage());
    case '/register':
      return MaterialPageRoute(builder: (_) => RegisterPage());
    default:
      return MaterialPageRoute(builder: (_) => MyHomePage());
  }
}
