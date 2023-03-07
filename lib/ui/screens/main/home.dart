import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onoy_kg/ui/screens/authorization/login_page.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home_page';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var logger = Logger();
  @override
  Widget build(BuildContext context) {
    logger.d(FirebaseAuth.instance.currentUser);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
            },
          )
        ],
      ),
      body: const Center(
        child: Text(''),
      ),
    );
  }
}
