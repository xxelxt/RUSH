import 'package:rush/app/app.dart';
import 'package:rush/config/admin_config.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options_admin.dart';

// Config for FlutterFire: flutterfire config --project=rush-8753d --android-package-name=com.xxelxt.rush.admin
// --out=lib/firebase_options_admin.dart --android-out=android/app/src/admin/google-services.json

// flutter run --flavor admin -t .\lib\main_admin.dart -v

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Thông báo nền: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FlavorConfig(
    flavor: Flavor.admin,
    flavorValues: FlavorValues(
      roleConfig: AdminConfig(),
    ),
  );

  runApp(
    const App(),
  );
}