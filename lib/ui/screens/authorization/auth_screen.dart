import 'package:flutter/material.dart';
import 'package:onoy_kg/models/user.dart';
import 'package:onoy_kg/ui/widgets/auth_form.dart';

import '../../widgets/titleAppBar.dart';

class AuthScreen extends StatefulWidget {

  AuthScreen({this.user});

  static const String id = '/auth_screen';

  final UserModel user;


  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: lines_longer_than_80_chars
    final Map<String, Object> rcvdData = ModalRoute.of(context).settings.arguments;
    print("A data ${rcvdData['user_type']}");
    print('A data $rcvdData');
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 24.0,
        backgroundColor: Colors.white,
        title: title(),
      ),
      body: AuthForm(rcvdData['user_type']),
    );
  }
}
