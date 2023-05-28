
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:onoy_kg/managers/token_manager.dart';
import 'package:onoy_kg/models/user.dart';
import 'package:onoy_kg/services/login_service.dart';
import 'package:rxdart/rxdart.dart';

import '../service_locator.dart';

class LoginManager {
  LoginManager() {
    _login.asyncMap((user) async {
      return await sl<LoginService>().createUser(user);
    }).listen((value) async {
      sl<TokenManager>().inRequestLogin.add('Login');
      _statusResponseSubject.add(value);
    });

    _register.asyncMap((user) async {
      return await sl<LoginService>().registerUser(user);
    }).listen((value) async {
      logger.d('register');
      _registerResponseSubject.add(value);
      //_userResponseSubject.add();
      logger.d(value);
      //_getUser.add('Logged in');
    });

    _getUser.listen((value) {
    //  logger.d('Login_manager: $value');
      _getUserData().listen((event) {
        _userResponseSubject.add(event);
        //logger.d(event.name);
      });
    });

    _setUser.listen((value) {
    //  logger.d(value);

      _setUserStream(value).listen((event) {
        _userResponseSubject.add(event);
      });
    });
  }

  final BehaviorSubject<UserModel> _login = BehaviorSubject<UserModel>();
  final BehaviorSubject<UserModel> _register = BehaviorSubject<UserModel>();
  // ignore: lines_longer_than_80_chars
  final BehaviorSubject<UserModel> _userResponseSubject = BehaviorSubject<UserModel>();
  final BehaviorSubject<String> _getUser = BehaviorSubject<String>();
  final BehaviorSubject<UserModel> _setUser = BehaviorSubject<UserModel>();
  // ignore: lines_longer_than_80_chars
  final PublishSubject<Response> _statusResponseSubject = PublishSubject<Response>();
  // ignore: lines_longer_than_80_chars
  final PublishSubject<Response> _registerResponseSubject = PublishSubject<Response>();
  // ignore: lines_longer_than_80_chars
  final PublishSubject<Response> _statusResponseFirebaseSubject = PublishSubject<Response>();

  var logger = Logger();

  Sink<UserModel> get inRequest => _login.sink;

  Sink<UserModel> get inRegister => _register.sink;

  Sink<String> get inUser => _getUser.sink;

  Sink<UserModel> get setUser => _setUser.sink;

  Stream<Response> get statusResponse$ => _statusResponseSubject.stream;
  // ignore: lines_longer_than_80_chars
  Stream<Response> get registerResponse => _registerResponseSubject.stream;

  // ignore: lines_longer_than_80_chars
  Stream<Response> get statusVerifyResponse$ => _statusResponseFirebaseSubject.stream;

  Stream<UserModel> get userResponse$ => _userResponseSubject.stream;

  Stream<UserModel> _getUserData() {
    return Stream.fromFuture(sl<LoginService>().getUser());
  }

  Stream<UserModel> _setUserStream(UserModel userModel) {
    return Stream.fromFuture(sl<LoginService>().setUser(userModel));
  }


  void dispose() {
    _login.close();
    _register.close();
    _getUser.close();
    _setUser.close();
    _statusResponseSubject.close();
    _statusResponseFirebaseSubject.close();
    _registerResponseSubject.close();
    _userResponseSubject.close();
  }
}
