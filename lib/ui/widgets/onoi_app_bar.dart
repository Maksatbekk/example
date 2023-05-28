import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onoy_kg/managers/login_manager.dart';
import 'package:onoy_kg/models/user.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import 'package:onoy_kg/ui/screens/add_item.dart';
import 'package:onoy_kg/ui/screens/add_transport.dart';
import 'package:onoy_kg/ui/screens/authorization/login_page.dart';
import 'package:onoy_kg/ui/screens/authorization/register_driver.dart';
import 'package:onoy_kg/ui/widgets/logo_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../managers/auth_button.dart';
import '../../managers/token_manager.dart';
import '../../service_locator.dart';


class OnoiAppbar extends StatefulWidget with PreferredSizeWidget {
  @override
  _OnoiAppbarState createState() => _OnoiAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}

class _OnoiAppbarState extends State<OnoiAppbar> {
  var _isLogin = false;

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  Future<String?> _getToken() async {
    final _prefs = SharedPreferences.getInstance();

    final prefs = await _prefs;

    //  final token = prefs.getString('jwt');
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

  Future<void> logOut() async {
    final _prefs = SharedPreferences.getInstance();

    final prefs = await _prefs;
    await prefs.setString('jwt', '');

    print('Logout');
    await _getToken();
    await Navigator.pushNamed(context, LoginPage.id);
    sl<TokenManager>().inRequestLogin.add('Update');
  }

  void logIn() {
    print('Login');
    Navigator.pushNamed(context, LoginPage.id);
  }

  final Widget svg = SvgPicture.asset(
    'assets/images/dolon_icon.svg',
      alignment: Alignment.topLeft, width: 100,
      fit: BoxFit.fitWidth,
  );

  @override
  Widget build(BuildContext context) {
    print(_isLogin);
    return AppBar(
      leadingWidth: 28.0,
      backgroundColor: Colors.white,
      title: LogoAppbar(),
      actions: [
          if (!_isLogin)
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)
                    ),
                    foregroundColor: Helpers.blueColor,
                    backgroundColor: Helpers.blueLightColor
                  ),
                    onPressed: () {
                      sl<AuthManager>().inRequestToggle.add('1');
                      logIn();

                      print('Raised Button Pressed $_isLogin');
                    },
                    child: const Text('Войти')),
                    
              ),
              // isLoginButton(),
              
         /* ElevatedButton(onPressed: (){
          logOut();
        }, child: const Text('Logout')),
 */
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
                return _statusResult(context, snapshot.data as UserModel);
              case ConnectionState.done:
                return Text('${snapshot.data} (closed)');
            }
          },
        ),
      ],
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
                   await Navigator.pushNamedAndRemoveUntil(
                    context, AddItem.id, ModalRoute.withName(AddItem.id),
                     arguments: {'userData': data},);
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
                (data.registered)
                    ? await Navigator.pushNamed(
                        context,
                        AddTransport.id,
                        arguments: {'userData': data},
                      )
                    : await Navigator.pushNamed(
                        context,
                        RegisterDriverScreen.id,
                        arguments: {'userData': data},
                      );
              }),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              ),
              foregroundColor: Helpers.blueColor,
              backgroundColor: Helpers.blueLightColor,
            ),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(4.0),
            // ),
            // textColor: Helpers.blueColor,
            // color: Helpers.blueLightColor,
            onPressed: () {
              //sl<AuthManager>().inRequestToggle.add('1');
              logIn();

              print('Raised Buttun Pressed $_isLogin');
            },
            child: const Text('Войти')),
      );
    }
  }
}
