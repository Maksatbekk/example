// ignore_for_file: omit_local_variable_types, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:onoy_kg/models/user.dart';
import 'package:onoy_kg/ui/widgets/auth_form.dart';

import '../../widgets/logo_appbar.dart';


class AuthScreen extends StatefulWidget {

  AuthScreen({required this.user});

  static const String id = '/auth_screen';

  final UserModel user;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? rcvdData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    print("A data ${rcvdData?['user_type']}");
    print('A data $rcvdData');
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 24.0,
        backgroundColor: Colors.white,
        title: title(),
      ),
      body: AuthForm(rcvdData?['user_type']),
    );
  }
}
