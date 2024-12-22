

import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final Map<String, dynamic> user;

  const Home({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue, ${user['prenom']} ${user['nom']} !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Numéro de téléphone : ${user['numero']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Taux d\'épargne : ${user['taux']}%',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}