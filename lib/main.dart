// ignore_for_file: use_key_in_widget_constructors
import 'package:cnmecab/modules/Notification/pages/push_notifications.dart';
import 'package:cnmecab/app/routes.dart';
import 'package:cnmecab/modules/home/pages/home_page.dart';
import 'package:cnmecab/modules/profile/pages/objetoUsuario.dart';
import 'package:cnmecab/modules/welcome/pages/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotification().initNotifications();
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
