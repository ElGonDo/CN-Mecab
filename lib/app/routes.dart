// ignore_for_file: unused_import, prefer_const_constructors

import 'package:cnmecab/modules/Home/pages/home_page.dart';
import 'package:cnmecab/modules/Home/pages/my_home_page.dart';
import 'package:cnmecab/modules/Login/pages/login_page.dart';
import 'package:cnmecab/modules/Register/pages/register_page.dart';
import 'package:cnmecab/modules/politics/pages/politics.dart';
import 'package:cnmecab/modules/politics/pages/Terms.dart';
import 'package:cnmecab/modules/welcome/pages/welcome_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/welcome':
      return MaterialPageRoute(builder: (_) => WelcomePage());
    case '/politics':
      return MaterialPageRoute(builder: (_) => politics());
    case '/terms':
      return MaterialPageRoute(builder: (_) => Terminos());
    case '/home':
      return MaterialPageRoute(builder: (_) => Paginahome());
    case '/login':
      return MaterialPageRoute(builder: (_) => LoginPage());
    case '/register':
      return MaterialPageRoute(builder: (_) => RegisterPage());
    default:
      return MaterialPageRoute(builder: (_) => WelcomePage());
  }
}
