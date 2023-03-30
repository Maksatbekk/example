import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:onoy_kg/service_locator.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
import 'package:onoy_kg/ui/screens/add_item.dart';
import 'package:onoy_kg/ui/screens/add_transport.dart';
import 'package:onoy_kg/ui/screens/authorization/auth_screen.dart';
import 'package:onoy_kg/ui/screens/authorization/register_driver.dart';
import 'package:onoy_kg/ui/screens/authorization/register_page.dart';
import 'package:onoy_kg/ui/screens/cabinet/cabinet_screen.dart';
import 'package:onoy_kg/ui/screens/main/home.dart';
import 'package:onoy_kg/ui/screens/main/main_screen.dart';

import 'managers/cargo_manager.dart';
import 'managers/login_manager.dart';
import 'managers/main_manager.dart';
import 'managers/token_manager.dart';
import 'ui/screens/authorization/login_page.dart';
import 'ui/screens/authorization/register_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Setup GetIt service locator
  setUpServiceLocator();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /*bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        print('True');
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    /*if(_error) {
      return Container(
        child: Text('Error'),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return CircularProgressIndicator();
    }*/
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gilroy',
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, 
              backgroundColor: Helpers.blueColor,
          ),
        ),
      ),
      initialRoute: MainScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        RegisterUser.id: (context) => RegisterUser(),
        RegisterDriverScreen.id: (context) => RegisterDriverScreen(),
        AddItem.id: (context) => AddItem(),
        AddTransport.id: (context) => AddTransport(),
        AuthScreen.id: (context) => AuthScreen(),
        // OTPScreen.id: (context) => OTPScreen(),
        MainScreen.id: (context) => MainScreen(),
        CabinetScreen.id: (context) => CabinetScreen(),
      },
    );
  }

  @override
  void dispose() {
    sl<LoginManager>().dispose();
    sl<MainManager>().dispose();
    sl<TokenManager>().dispose();
    sl<CargoManager>().dispose();

    super.dispose();
  }
}
