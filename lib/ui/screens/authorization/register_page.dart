import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onoy_kg/models/user.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import 'package:onoy_kg/ui/screens/authorization/auth_screen.dart';

class RegisterPage extends StatelessWidget {

  static const String id = '/register_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        top: false,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Регистрируюсь как ...',
              style: TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    color: Colors.transparent,
                    elevation: 0,
                    highlightElevation: 0,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        AuthScreen.id,
                        arguments: {'user_type': 'driver'},
                      );
                    },
                    child: Text(
                      'Водитель',
                      style: Helpers.header1BlueTextStyle,
                    )),
                RaisedButton(
                  color: Colors.transparent,
                  elevation: 0,
                  highlightElevation: 0,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      AuthScreen.id,
                      arguments: {'user_type': 'client'},
                    );
                  },
                  child: Text(
                    'Владелец груза',
                    style: Helpers.header1BlueTextStyle,
                  ),
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}
