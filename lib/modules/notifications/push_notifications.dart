// ignore_for_file: avoid_print, unused_local_variable

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    //print('token: $fCMToken');
  }
}
