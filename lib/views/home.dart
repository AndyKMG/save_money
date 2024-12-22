import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_receiver/sms_receiver.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> user;

  const Home({super.key, required this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _filteredMessages = [];
  String? _textContent = 'Waiting for messages...';
  SmsReceiver? _smsReceiver;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _requestSmsPermission();
    _smsReceiver = SmsReceiver(onSmsReceived, onTimeout: onTimeout);

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _startListening(); // This will run every second.
    });
  }

  void onSmsReceived(String? message) {
    // Afficher un message de succès ou de redirection
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(" onSmsReceived message ")),
    );
    print(" onSmsReceived message");
    setState(() {
      _textContent = message;
    });
  }

  void onTimeout() {
    setState(() {
      _textContent = 'Timeout!!!';
    });
  }

  void _startListening() async {
    print("_startListening was called ");
    if (_smsReceiver == null) return;
    await _smsReceiver?.startListening();
    setState(() {
      _textContent = 'Waiting for messages...';
    });
  }

  void _stopListening() async {
    if (_smsReceiver == null) return;
    await _smsReceiver?.stopListening();
    setState(() {
      _textContent = 'Listener Stopped';
    });
  }

  Future<void> _requestSmsPermission() async {
    var status = await Permission.sms.status;
    if (status.isGranted) {
      _fetchSmsMessages();
    } else if (status.isDenied) {
      if (await Permission.sms.request().isGranted) {
        _fetchSmsMessages();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Permission refusée pour accéder aux SMS.')),
        );
      }
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Permission refusée définitivement. Veuillez accorder l\'accès aux SMS dans les paramètres.')),
      );
    }
  }

  Future<void> _fetchSmsMessages() async {
    List<SmsMessage> messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
    );
    setState(() {
      _filteredMessages = messages
          .where((message) =>
              message.body != null &&
              message.body!.startsWith("Transfert effectue pour"))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue, ${widget.user['prenom']} ${widget.user['nom']} !',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Numéro de téléphone : ${widget.user['numero']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Taux d\'épargne : ${widget.user['taux']}%',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            Text(_textContent ?? 'empty'),
            ElevatedButton(
              onPressed: _fetchSmsMessages,
              child: const Text('Afficher les SMS filtrés'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredMessages.isEmpty
                  ? const Text('Aucun SMS filtré trouvé.')
                  : ListView.builder(
                      itemCount: _filteredMessages.length,
                      itemBuilder: (context, index) {
                        final message = _filteredMessages[index];
                        return ListTile(
                          title: Text(message.body ?? ""),
                          subtitle: Text(message.date.toString()),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
