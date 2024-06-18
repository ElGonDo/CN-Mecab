// ignore_for_file: use_key_in_widget_constructors, avoid_print
import 'package:cnmecab/app/routes.dart';
import 'package:cnmecab/modules/home/pages/homePage.dart';
import 'package:cnmecab/modules/notifications/push_notifications.dart';
import 'package:cnmecab/modules/profile/services/objectUser.dart';
import 'package:cnmecab/modules/welcome/pages/welcome_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotification().initNotifications();
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.playIntegrity);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              // Si el usuario está autenticado, llama a initializeUserProfile
              UserProfileSingleton().initializeUserProfile();
              return const Paginahome();
            } else {
              return const WelcomePage();
            }
          }
        },
      ),
    );
  }
}
