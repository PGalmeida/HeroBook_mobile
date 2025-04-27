import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:herobook/firebase_options.dart';
import 'package:herobook/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyChzlo9TixY_3v5uAc7H_5PaqRd7ATic-A",
        authDomain: "herobook-app.firebaseapp.com",
        projectId: "herobook-app",
        storageBucket: "herobook-app.firebasestorage.app",
        messagingSenderId: "382734647968",
        appId: "1:382734647968:web:793b83ba5173edaab1bfc5"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
