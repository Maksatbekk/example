// ignore_for_file: unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onoy_kg/managers/login_manager.dart';
import 'package:onoy_kg/managers/token_manager.dart';
import 'package:onoy_kg/models/user.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import 'package:onoy_kg/ui/screens/authorization/login_page.dart';
import 'package:onoy_kg/ui/screens/cabinet/cabinet_screen.dart';
import 'package:onoy_kg/ui/screens/cabinet/my_list.dart';
import 'package:onoy_kg/ui/screens/main/main_screen.dart';
import 'package:recase/recase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service_locator.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF0062ac),
              ),
              accountName: _name(),
              accountEmail: _number(),
              otherAccountsPictures: [_icon()],
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.bookmark_border_sharp,
                color: Colors.black,
              ),
              title: const Text('Сохранения'),
              onTap: () => MyList(),
            ),
            cabinetMenu(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.black),
              title: const Text('Выход'),
              onTap: () => logOut(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logOut(BuildContext context) async {
    final _prefs = SharedPreferences.getInstance();

    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setString('jwt', '');
    print('Logout $result');
    final toke = prefs.getString('jwt');
    print('LogoutToken $toke');

    print('Logout');
    sl<TokenManager>().inRequestLogin.add('Update');
    await Navigator.popAndPushNamed(context, MainScreen.id);
  }

  Widget _name() {
    return StreamBuilder<UserModel>(
      stream: sl<LoginManager>().userResponse$,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('');
          case ConnectionState.waiting:
            return const Text('');
          case ConnectionState.active:
            print(snapshot.data!.name);
            return _nameValue(snapshot.data as UserModel);
          case ConnectionState.done:
            return Text('${snapshot.data} (closed)');
        }
// unreachable
      },
    );
  }

  Widget _nameValue(UserModel data) {
    String name;
    String surName;
    print(data.name);
    if (data.name != null) {
      name = data.name!.titleCase;
    } else {
      name = '';
    }
    if (data.surname != null) {
      surName = data.surname!.titleCase;
    } else {
      surName = '';
    }

    return Text('$name $surName', style: Helpers.header1WhiteTextStyle);
  }

  Widget _icon() {
    return StreamBuilder<UserModel>(
      stream: sl<LoginManager>().userResponse$,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('');
          case ConnectionState.waiting:
            return const Text('');
          case ConnectionState.active:
            return Row(
              children: [
                (snapshot.data!.userType == 'driver')
                    ? const Icon(Icons.drive_eta_sharp, color: Colors.white)
                    : const Text(''),
                (snapshot.data!.userType == 'client')
                    ? const Icon(Icons.shopping_cart_sharp, color: Colors.white)
                    : const Text('')
              ],
            );

          case ConnectionState.done:
            return Text('${snapshot.data} (closed)');
        }
// unreachable
      },
    );
  }

  Widget _number() {
    return StreamBuilder<UserModel>(
      stream: sl<LoginManager>().userResponse$,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('');
          case ConnectionState.waiting:
            return const Text('');
          case ConnectionState.active:
            return Row(
              children: [
                (snapshot.data!.userType == 'driver')
                    ? Text('Водитель: ', style: Helpers.header2WhiteTextStyle)
                    : const Text(''),
                (snapshot.data!.userType == 'client')
                    ? Text('Клиент: ', style: Helpers.header2WhiteTextStyle)
                    : const Text(''),
                (snapshot.data!.phoneNumber != null)
                    ? Text(
                        snapshot.data!.phoneNumber as String,
                        style: Helpers.header2WhiteTextStyle,
                      )
                    : const Text(''),
              ],
            );
          case ConnectionState.done:
            return Text('${snapshot.data} (closed)');
        }
// unreachable
      },
    );
  }

  Widget cabinetMenu() {
    return StreamBuilder<UserModel>(
      stream: sl<LoginManager>().userResponse$,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('');
          case ConnectionState.waiting:
            return const Text('');
          case ConnectionState.active:
            final value = snapshot.data!.phoneNumber;
            print('CabinetMenu: $value');

            return ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.black),
              title: const Text('Кабинет'),
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  value != null ? CabinetScreen.id : LoginPage.id,
                );
              },
            );

          case ConnectionState.done:
            return Text('${snapshot.data} (closed)');
        }
// unreachable
      },
    );
  }
}
