// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onoy_kg/managers/login_manager.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import 'package:onoy_kg/ui/screens/authorization/register_page.dart';
import 'package:onoy_kg/ui/screens/main/main_screen.dart';
import 'package:onoy_kg/ui/widgets/footer.dart';

import '../../../models/user.dart';
import '../../../service_locator.dart';
import '../../widgets/logo_appbar.dart';
import '../main/home.dart';

class LoginPage extends StatefulWidget {
  static const String id = '/login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _user = UserModel();
  var loading = false;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() => loading = true);
      sl<LoginManager>().inRequest.add(_user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: title(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20.0),
                        Text(
                          'Войдите в свой аккаунт',
                          style: Helpers.titleTextStyle,
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Номер телефона: +996',
                              hintStyle: Helpers.hintStyle,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            validator: Helpers.validateMobile,
                            onSaved: (value) {
                              _user.phoneNumber = value;
                            }),
                        const SizedBox(height: 8.0),
                        TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Пароль',
                              hintStyle: Helpers.hintStyle,
                              border: const OutlineInputBorder(),
                            ),
                            obscureText: true,
                            obscuringCharacter: '*',
                            validator: Helpers.validatePassword,
                            onSaved: (value) {
                              _user.password = value;
                            }),
                        const SizedBox(height: 8.0),
                        const Align(
                            alignment: Alignment.centerRight,
                            child: Text('Забыл пароль',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Helpers.blueColor,
                                ))),
                        const SizedBox(height: 30.0),
                        Visibility(
                          visible: loading,
                          child: StreamBuilder<Response>(
                            stream: sl<LoginManager>().statusResponse$,
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<Response> snapshot,
                            ) {
                              if (snapshot.hasError) {
                                return Text(
                                  'Error: ${snapshot.error}',
                                );
                              }
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return const Text('');
                                case ConnectionState.waiting:
                                  return const CircularProgressIndicator();
                                case ConnectionState.active:
                                  return _statusResult(context, snapshot.data!);
                                case ConnectionState.done:
                                  return Text('${snapshot.data} (closed)');
                              }
                              return null; // unreachable
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        _buttons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: footer());
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 30,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            // highlightElevation: 0,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, RegisterPage.id);
            },
            child: const Text(
              'Регистрация',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Helpers.blueColor,
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 30,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(10),
              foregroundColor: Colors.white,
              backgroundColor: Helpers.blueColor,
            ),
            onPressed: _trySubmit,
            child: const Text(
              'Войти',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusResult(BuildContext context, Response data) {
    print('Response status ${data.statusCode}');
    Future.delayed(Duration.zero, () async {
      if (data.statusCode == 200) {
        await Navigator.pushNamed(context, MainScreen.id);
        (route) => false;
        Navigator.pop(context);

        await Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.id, ModalRoute.withName(MainScreen.id));
        await Navigator.pushNamedAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()) as String,
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Введен неверный логин или пароль'),
          duration: const Duration(seconds: 5),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    });

    return Container();
  }
}
