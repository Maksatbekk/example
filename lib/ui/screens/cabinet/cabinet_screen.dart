// ignore_for_file: dead_code, unused_import

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onoy_kg/managers/login_manager.dart';
import 'package:onoy_kg/managers/users_manager.dart';
import 'package:onoy_kg/models/user.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import 'package:onoy_kg/ui/helpers/request_command.dart';
import 'package:onoy_kg/ui/screens/add_item.dart';
import 'package:onoy_kg/ui/screens/cabinet/profile.dart';

import '../../../service_locator.dart';
import '../add_transport.dart';
import 'my_list.dart';


class CabinetScreen extends StatelessWidget {
  static const String id = '/cabinet_screen';

  @override
  Widget build(BuildContext context) {
    sl<UsersManager>().inRequest.add(RequestCommand.UPDATE);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 24.0,
        backgroundColor: Colors.white,
        title: const Text(
          'DOLON',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
            color: Color(0xff3B4256),
          ),
        ),
        actions: [
          StreamBuilder<UserModel>(
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
                  return _statusResult(context, snapshot.data!);
                case ConnectionState.done:
                  return Text('${snapshot.data} (closed)');
              }
              return null; // unreachable
            },
          ),
        ],
      ),
      body: Scaffold(
        body: DefaultTabController(
          length: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                ButtonsTabBar(
                  duration: 10,
                  buttonMargin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  backgroundColor: Helpers.blueColor,
                  unselectedBackgroundColor: Colors.white,
                  unselectedLabelStyle: const TextStyle(
                    color: Helpers.blueColor,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.directions_car),
                      text: 'Мои заказы',
                    ),
                    Tab(
                      icon: Icon(Icons.account_box_rounded),
                      text: 'Профиль',
                    ),
                    Tab(
                      icon: Icon(Icons.bookmark_border_sharp),
                      text: 'Сохранения',
                    ),
                    Tab(
                      icon: Icon(Icons.add_alert_rounded),
                      text: 'Уведомления',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      Container(child: MyList()),
                      Profile(),
                      const Center(
                        child: Icon(Icons.directions_car),
                      ),
                      const Center(
                        child: Icon(Icons.directions_transit),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusResult(BuildContext context, UserModel data) {
    if (data.userType == 'client') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Helpers.blueColor,
          ),
          child: IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                // await FirebaseAuth.instance.signOut();
                await Navigator.pushNamed(
                  context,
                  AddItem.id,
                  arguments: {'userData': data},
                );
              }),
        ),
      );
    } else if (data.userType == 'driver') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
        child: Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Helpers.blueColor,
          ),
          child: IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                // await FirebaseAuth.instance.signOut();
                await Navigator.pushNamedAndRemoveUntil(
                    context, AddTransport.id,
                     ModalRoute.withName(AddTransport.id),
                    arguments: {'userData': data},);

                // await Navigator.pushNamed(context, 
                //AddTransport.id, arguments: {'userData': data});
              }),
            ),
      );
    } else {
      return const Text('');
    }
  }
}
  