<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:material_hub/auth/auth.dart';
import 'package:material_hub/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Activate Firebase App Check using Play Integrity for Android
  await FirebaseAppCheck.instance.activate(
    // webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: const MaterialApp(
        title: 'Material Hub',
        home: LandingPage(),
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:material_hub/auth/auth.dart';
import 'package:material_hub/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Activate Firebase App Check using Play Integrity for Android
  await FirebaseAppCheck.instance.activate(
    // webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: const MaterialApp(
        title: 'Material Hub',
        home: LandingPage(),
      ),
    );
  }
}
>>>>>>> 8ddb56bed4ea68597595ff99aef8608671358442
