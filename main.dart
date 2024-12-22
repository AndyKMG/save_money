import 'package:flutter/material.dart';
import 'dart:async';

import 'package:save_money/views/connexion.dart';
import 'package:save_money/views/inscription.dart'; // Pour utiliser Timer

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Launch(),
      routes: {
        '/inscription': (context) => Inscription(),
        '/connexion': (context) => Connexion(),
      },
    );
  }
}

class Launch extends StatefulWidget {
  @override
  _LaunchState createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {
  @override
  void initState() {
    super.initState();
    // Rediriger après 2 secondes
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/connexion');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAEFF7F), // Couleur de fond verte claire
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Assure-toi que l'image est dans le dossier 'assets'
          width: 350,
          height: 350,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
