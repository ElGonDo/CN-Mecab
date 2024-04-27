// ignore_for_file: unused_import, prefer_const_constructors

import 'package:cnmecab/modules/auth/register/pages/register_page.dart';
import 'package:cnmecab/modules/auth/login/pages/login_page.dart';
import 'package:cnmecab/modules/notifications/pages/notifications.dart';
import 'package:cnmecab/modules/publications/postPublications/pages/postPublications.dart';
import 'package:cnmecab/modules/search/Search.dart';
import 'package:cnmecab/modules/forms/pages/formCreator.dart';
import 'package:cnmecab/modules/forms/pages/formPromoter.dart';
import 'package:cnmecab/modules/forms/pages/formVisitor.dart';
import 'package:cnmecab/modules/Home/pages/home_page.dart';
import 'package:cnmecab/modules/home/pages/home_body.dart';
import 'package:cnmecab/modules/politics/pages/politics.dart';
import 'package:cnmecab/modules/politics/pages/Terms.dart';
import 'package:cnmecab/modules/profile/pages/profile.dart';
import 'package:cnmecab/modules/profile/pages/profileimageCreators.dart';
import 'package:cnmecab/modules/profile/pages/profileimageVisitor.dart';
import 'package:cnmecab/modules/profile/pages/profileNew.dart';
import 'package:cnmecab/modules/welcome/pages/welcome_page.dart';
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
    case '/ProfileNew':
      return MaterialPageRoute(builder: (_) => ProfilePage());
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
    case '/bodyPage':
      return MaterialPageRoute(builder: (_) => BodyPage());
    case '/publicar':
      return MaterialPageRoute(builder: (_) => Publicar());
    case '/Search':
      return MaterialPageRoute(builder: (_) => Search());
    case '/notificaciones':
      return MaterialPageRoute(builder: (_) => Notificacion());
    case '/imagesprofileVisitor':
      return MaterialPageRoute(builder: (_) => ImageListScreen());
    case '/imagesprofileCreators':
      return MaterialPageRoute(builder: (_) => PublicarCreators());
    default:
      return MaterialPageRoute(builder: (_) => WelcomePage());
  }
}
