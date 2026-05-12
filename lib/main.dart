import 'package:flutter/material.dart';

import 'features/Authentication/Pages/CreatePasswordPage.dart';
import 'features/Authentication/Pages/SignInPage.dart';
import 'features/splash_onboarding/pages/SplashPage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const Splashpage(),
      // home: const SignInPage(),
      home: const CreatePasswordScreen(),
    );
  }
}
