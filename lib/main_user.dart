import 'package:rush/app/app.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:rush/config/user_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options_user.dart';

// Config for FlutterFire: flutterfire config --project=rush-8753d --android-package-name=com.xxelxt.rush.user
// --out=lib/firebase_options_user.dart --android-out=android/app/src/user/google-services.json

// flutter run --flavor user -t .\lib\main_user.dart -v

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlavorConfig(
    flavor: Flavor.user,
    flavorValues: FlavorValues(
      roleConfig: UserConfig(),
    ),
  );

  runApp(
    const App(),
  );
}
