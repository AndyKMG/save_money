import 'package:flutter/material.dart';
import 'package:save_money/views/home.dart';
import 'package:save_money/views/inscription.dart';
import 'package:save_money/db/db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Connexion(),
      routes: {
        '/inscription': (context) => Inscription(),
      },
    );
  }
}

class Connexion extends StatefulWidget {
  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  String numero = '';
  final _formKey = GlobalKey<FormState>();

  final DbHelper dbHelper =
      DbHelper(); // Instance du helper pour la base de données
  final TextEditingController numeroController =
      TextEditingController(); // Contrôleur pour le champ de saisie

  // Fonction pour vérifier si le numéro existe dans la base de données
  void checkUser(numero) async {
    // final numero =
    //     numeroController.text.trim(); // Récupère le numéro sans espace

    if (numero.isEmpty || numero.length == 0) {
      // Afficher un message de succès ou de redirection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(numero)),
      );
      // Affiche une alerte si le champ est vide
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Erreur"),
          content: Text("Veuillez entrer un numéro de téléphone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Recherche de l'utilisateur dans la base de données
    final user = await dbHelper.getUserByNumero(numero);
    if (user != null) {
      // Si l'utilisateur est trouvé, redirige vers la page UserDetails
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(user: user),
        ),
      );
    } else {
      // Si l'utilisateur n'est pas trouvé, affiche une alerte
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Erreur"),
          content: Text("Utilisateur non trouvé."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Traitement de l'envoi
      print('Numéro envoyé: $numero');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAEFF7F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  width: 350,
                  height: 350,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                Text(
                  'Connectez-vous',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Numéro de téléphone',
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      setState(() {
                       // print(numero);
                        numero = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un numéro de téléphone valide';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: Colors.black,
                    textStyle: TextStyle(color: Color(0xFFAEFF7F)),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => {print(numero), checkUser(numero)},
                  child: Text(
                    'Envoi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/inscription');
                  },
                  child: Text(
                    'Êtes-vous inscrit ?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
