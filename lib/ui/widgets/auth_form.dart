// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onoy_kg/managers/login_manager.dart';
import 'package:onoy_kg/models/user.dart';
import 'package:onoy_kg/models/verify_result.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import 'package:onoy_kg/ui/screens/authorization/login_page.dart';
import 'package:onoy_kg/ui/screens/authorization/otp.dart';
import 'package:onoy_kg/ui/screens/main/main_screen.dart';

import '../../service_locator.dart';


class AuthForm extends StatefulWidget {
  AuthForm(this.userType);

  final String userType;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _user = UserModel();
  var loading = false;
  var textColor = Helpers.hintColor;

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() => loading = true);
      _user.userType = widget.userType;
      print(_user.name);
      print(_user.surname);
      print(_user.phoneNumber);
      print(_user.password);
      print(_user.userType);
      print(_user.uidToken);

      sl<LoginManager>().inRegister.add(_user);

      /* Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OTPScreen(_user),
      ));*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Text(
                  'Регистрация в Onoi.kg',
                  style: Helpers.titleTextStyle,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Введите ваше имя и номер, на который \n '
                  'мы отправим код подтверждения',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const ValueKey('name'),
                  decoration: InputDecoration(
                    hintText: 'Имя',
                    hintStyle: Helpers.hintStyle,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 2) {
                      return 'Поле должно быть от 2 и'
                          ' выше символов длиной и не содержать чисел';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _user.name = value;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  key: const ValueKey('surname'),
                  decoration: InputDecoration(
                    hintText: 'Фамилия',
                    hintStyle: Helpers.hintStyle,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 2) {
                      return 'Поле должно быть от 2 и '
                          'выше символов длиной и не содержать чисел';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _user.surname = value;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  key: const ValueKey('number'),
                  decoration: InputDecoration(
                    hintText: 'Номер телефона: +996',
                    hintStyle: Helpers.hintStyle,
                    border: const OutlineInputBorder(),
                  ),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  // validator: Helpers.validateMobile(),
                  onChanged: (value) async {
                    print(value);
                    final regExp = RegExp(Helpers.pattern);
                    print('HasMatched${regExp.hasMatch(value)}');

                    if (value.isEmpty) {
                      setState(() {
                        textColor = Helpers.hintColor;
                      });
                      print('Неправильно введенный формат номера телефона');
                    } else if (!regExp.hasMatch(value)) {
                      setState(() {
                        textColor = Helpers.hintColor;
                      });
                      print('Неправильно введенный формат номера телефона');
                    } else if (regExp.hasMatch(value)) {
                      print('Verify');
                      setState(() {
                        textColor = Helpers.blueColor;
                      });
                      _user.phoneNumber = value;

                      final result = await Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => OTPScreen(_user),
                      ));
                      _user.uidToken = result;
                      print(result);
                    }
                  },
                  onSaved: (value) {
                    _user.phoneNumber = value;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  key: const ValueKey('password'),
                  decoration: InputDecoration(
                    hintText: 'Пароль',
                    hintStyle: Helpers.hintStyle,
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                  obscuringCharacter: '*',
                  textInputAction: TextInputAction.next,
                  // validator: Helpers.validatePassword,
                  onSaved: (value) {
                    _user.password = value;
                  },
                ),
                const SizedBox(height: 30.0),
                Visibility(
                  visible: loading,
                  child: StreamBuilder<Response>(
                    stream: sl<LoginManager>().registerResponse,
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
                          return _statusResult2(context, snapshot.data as Response);
                        case ConnectionState.done:
                          return Text('${snapshot.data} (closed)');
                      }
// unreachable
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        
                        ),
                        // color: Colors.transparent,
                        // elevation: 0,
                        // highlightElevation: 0,
                        onPressed: () {
                          Navigator.pushNamed(context, LoginPage.id);
                        },
                        child: const Text(
                          'Войти',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Helpers.blueColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(10),
                          foregroundColor: Colors.white,
                          backgroundColor: Helpers.blueColor,
                        ),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        // ),
                        // padding: const EdgeInsets.all(10),
                        // textColor: Colors.white,
                        // color: Helpers.blueColor,
                        onPressed: () {
                          _trySubmit();
                        },
                        child: const Text(
                          'Зарегистрироваться',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusResult2(BuildContext context, Response data) {
    print('Response status ${data.statusCode}');
    Future.delayed(Duration.zero, () async {
      if (data.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:  Text('Пользователь успешно создан!'),
              duration:  Duration(seconds: 5),
              backgroundColor: Helpers.greenColor),
        );
        await Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.id, ModalRoute.withName(MainScreen.id));
        /* await Navigator.pushNamedAndRemoveUntil()
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false);*/

      } else if (data.statusCode == 400) {
        final jsonData = json.decode(data.body);
        final create = VerifyResult.fromJson(jsonData);
        print(create.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(create.message),
              duration: const Duration(seconds: 2),
              backgroundColor: Theme.of(context).colorScheme.error),
        );
      } else {
        /*  Scaffold.of(context).showSnackBar(SnackBar(
          content: const Text('Введен неверный логин или пароль'),
          backgroundColor: Theme.of(context).errorColor,
        ));*/

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: const Text('Введен неверный логин или пароль'),
              duration: const Duration(seconds: 2),
              backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    });

    return Container();
  }
}
