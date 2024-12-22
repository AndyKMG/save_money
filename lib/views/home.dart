import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatelessWidget {
  final Map<String, dynamic> user;

  const Home({Key? key, required this.user}) : super(key: key);

  Future<void> requestSmsPermission(BuildContext context) async {
    final status = await Permission.sms.request(); // Demande la permission SMS

    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission accordée pour accéder aux SMS.')),
      );
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission refusée.')),
      );
    } else if (status.isPermanentlyDenied) {
      // Redirige l'utilisateur vers les paramètres
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Permission refusée définitivement'),
          content: Text(
            'Veuillez accorder l\'accès aux SMS dans les paramètres.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Ouvre les paramètres de l'application
              },
              child: Text('Ouvrir les paramètres'),
            ),
          ],
        ),
      );
    }
  }

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
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => requestSmsPermission(context), // Demande de permission
              child: Text('Demander l\'accès aux SMS'),
            ),
          ],
        ),
      ),
    );
  }
}