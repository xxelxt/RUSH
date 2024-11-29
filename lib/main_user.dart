import 'package:rush/app/app.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:rush/config/user_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

// flutter run --flavor user -t .\lib\main_user.dart
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
