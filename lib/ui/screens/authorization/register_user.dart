// ignore_for_file: unused_import, unnecessary_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import 'package:onoy_kg/ui/screens/authorization/login_page.dart';
import 'package:onoy_kg/ui/widgets/footer.dart';

import '../../../models/user.dart';
import '../add_item.dart';

class RegisterUser extends StatelessWidget {
  static const String id = '/register_user';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _user = UserModel();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: const Text(
            'ONOI',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w900,
              color: Color(0xff3B4256),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Helpers.blueColor,
                ),
                child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AddItem.id);
                      Navigator.pop(context);
                    }),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ), onPressed: () {  },

            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Как к вам обращаться ?',
                          hintStyle: Helpers.hintStyle,
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _user.name = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Номер для регистрации',
                                hintStyle: Helpers.hintStyle,
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter number';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _user.phoneNumber = value;
                              },
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          SvgPicture.asset(
                            'assets/images/telegram.svg',
                            fit: BoxFit.cover,
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 10),
                          SvgPicture.asset(
                            'assets/images/whatsapp.svg',
                            fit: BoxFit.cover,
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Добавить номер',
                        style: Helpers.smallBlueTextStyle,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 80,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
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
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0)
                              ),
                              padding: const EdgeInsets.all(10),
                              foregroundColor: Colors.white,
                              backgroundColor: Helpers.blueColor,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                print('Process data');
                                _formKey.currentState!.save();
                                print('Name: ${_user.name}');
                                print('Number: ${_user.phoneNumber}');
                              } else {
                                print('Error');
                              }
                            },
                            child: const Text(
                              'Зарегистрироваться',
                              style: TextStyle(
                                fontSize: 14.0,
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
        ),
        bottomNavigationBar: footer());
  }
}
