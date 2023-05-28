// ignore_for_file: unused_import, unused_field, unused_local_variable, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onoy_kg/managers/cargo_manager.dart';
import 'package:onoy_kg/managers/main_manager.dart';
import 'package:onoy_kg/managers/token_manager.dart';
import 'package:onoy_kg/models/results.dart';
import 'package:onoy_kg/service_locator.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import 'package:onoy_kg/ui/helpers/request_command.dart';
import 'package:onoy_kg/ui/widgets/drawer_menu.dart';
import 'package:onoy_kg/ui/widgets/onoi_app_bar.dart';
import 'package:onoy_kg/ui/widgets/transport_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'main_tabs.dart';

class MainScreen extends StatefulWidget {
  static const String id = '/main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey _scaffoldKey = GlobalKey();

  final logger = Logger();
  var _isLogin = false;

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  Future<String?> _getToken() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    print('Token value $token');
    if (token == null || token == '') {
      if (!mounted) {
        return token;
      }
      setState(() => _isLogin = false);
    } else {
      if (!mounted) {
        return token;
      }
      setState(() => _isLogin = true);
    }
    return token;
  }

  @override
  Widget build(BuildContext context) {
    //sl<CargoManager>().inRequest.add(RequestCommand.UPDATE);
   // sl<LoginManager>().inUser.add('MainStarted1');
    final query = Results();


    sl<MainManager>().inRequestToggle.add(query);
    sl<CargoManager>().inRequestTransportGet.add(query);

    sl<TokenManager>().inRequestLogin.add('Main');

    return Scaffold(
      key: _scaffoldKey,
      appBar: OnoiAppbar(),
      drawer: DrawerMenu(),
      body: MainTabs(),
    );
  }

  Future<void> logOut(BuildContext context) async {

    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setString('jwt', '');
     final query = Results();
    //sl<CargoManager>().inRequest.add(RequestCommand.UPDATE);
   // sl<LoginManager>().inUser.add('MainStarted2');
    sl<MainManager>().inRequestToggle.add(query);
    sl<CargoManager>().inRequestTransportGet.add(query);

    sl<TokenManager>().inRequestLogin.add('MainL');

    await Navigator.popAndPushNamed(context, MainScreen.id);
  }


  void displayModalBottomSheet(BuildContext context) {
    sl<MainManager>().inRequestToggle.add(0 as Results);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              child: Wrap(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Color(0xffDB0000),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Text('Фильтр', style: Helpers.header1TextStyle),
                      const Text('Сбросить',
                          style: TextStyle(
                              color: Color(0xffDB0000),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ToggleSwitch(
                        minWidth: 100,
                        fontSize: 16.0,
                        // activeBgColor: Colors.white,
                        activeFgColor: Colors.black,
                        inactiveBgColor: Colors.white,
                        inactiveFgColor: const Color(0xff909090),
                        labels: const ['Груз', 'Транспорт'],
                        onToggle: (index) {
                          sl<MainManager>().inRequestToggle.add(index as Results);
                        },
                      ),
                      InkWell(
                        onTap: () => displayModalBottomSheet(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0xffE5F2FF),
                          ),
                          child: Row(children: [
                            const Icon(
                              Icons.access_time_sharp,
                              color: Helpers.blueColor,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              'За все время',
                              style: Helpers.header1BlueTextStyle,
                            )
                          ]),
                        ),
                      )
                    ],
                  ),
                  StreamBuilder(
                      stream: sl<MainManager>().currentSelection$,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<Results> snapshot,
                      ) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const Text('Select lot');
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          case ConnectionState.active:
                            return _contentBottom(snapshot.data as int);
                          case ConnectionState.done:
                            return Text('${snapshot.data} (closed)');
                        }
                        // ignore: dead_code
                        return null;
                      }),
                ],
              ),
            ),
          );
        });
  }

  Widget _contentBottom(int data) {
    switch (data) {
      case 0:
        return const Text('Empty');
      case 1:
        return TransportWidget();
    }
    return Container();
  }
}
