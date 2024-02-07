// ignore_for_file: unused_import, prefer_const_constructors

import 'package:cnmecab/modules/Notification/pages/Notification.dart';
import 'package:cnmecab/modules/Search/Search.dart';
import 'package:cnmecab/modules/forms/pages/FormC.dart';
import 'package:cnmecab/modules/forms/pages/FormP.dart';
import 'package:cnmecab/modules/forms/pages/FormV.dart';
import 'package:cnmecab/modules/Home/pages/home_page.dart';
import 'package:cnmecab/modules/Login/pages/login_page.dart';
import 'package:cnmecab/modules/Register/pages/register_page.dart';
import 'package:cnmecab/modules/home/pages/home_body.dart';
import 'package:cnmecab/modules/politics/pages/politics.dart';
import 'package:cnmecab/modules/politics/pages/Terms.dart';
import 'package:cnmecab/modules/Saved/pages/saved_page.dart';
import 'package:cnmecab/modules/profile/pages/profile.dart';
import 'package:cnmecab/modules/profile/pages/profileimage.dart';
import 'package:cnmecab/modules/welcome/pages/welcome_page.dart';
import 'package:cnmecab/modules/PostUp/pages/PostsUpload.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/welcome':
      return MaterialPageRoute(builder: (_) => WelcomePage());
    case '/FormV':
      return MaterialPageRoute(builder: (_) => FormVPage());
    case '/FormC':
      return MaterialPageRoute(builder: (_) => FormCPage());
    case '/FormP':
      return MaterialPageRoute(builder: (_) => FormPPage());
    case '/Profile':
      return MaterialPageRoute(builder: (_) => ProfileScreen());
    case '/politics':
      return MaterialPageRoute(builder: (_) => politics());
    case '/saved':
      return MaterialPageRoute(builder: (_) => Guardados());
    case '/terms':
      return MaterialPageRoute(builder: (_) => Terminos());
    case '/home':
      return MaterialPageRoute(builder: (_) => Paginahome());
    case '/login':
      return MaterialPageRoute(builder: (_) => LoginPage());
    case '/register':
      return MaterialPageRoute(builder: (_) => RegisterPage());
    case '/bodyPage':
      return MaterialPageRoute(builder: (_) => BodyPage());
    case '/publicar':
      return MaterialPageRoute(builder: (_) => Publicar());
    case '/Search':
      return MaterialPageRoute(builder: (_) => Search());
    case '/notificaciones':
      return MaterialPageRoute(builder: (_) => Notificacion());
    case '/imagesprofile':
      return MaterialPageRoute(builder: (_) => ImageListScreen());
    default:
      return MaterialPageRoute(builder: (_) => WelcomePage());
  }
}
