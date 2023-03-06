// ignore_for_file: unused_element

import 'package:logger/logger.dart';
import 'package:onoy_kg/service_locator.dart';
import 'package:onoy_kg/services/tokenStatus.dart';
import 'package:rxdart/rxdart.dart';

import 'login_manager.dart';

class TokenManager {
  TokenManager(){
/*
    _getToken().listen((event) {
      logger.d(event);
      _isLoginValue.add(event);
    });*/

    _isLogin.listen((value) {
    //  logger.d('_isLoger : $value');
      //_setToken(value);
     /* _getToken().listen((event) {
        logger.d('_isLoger : $event');
        sl<LoginManager>().inUser.add('MainStarted');

        _isLoginValue.add(event);
      });*/

      _getTokenValue().listen((event) {
        sl<LoginManager>().inUser.add(event);
      });


    });
  }
  final BehaviorSubject<String> _isLogin = BehaviorSubject<String>();
  final BehaviorSubject<bool> _isLoginValue = BehaviorSubject<bool>();

  Sink get inRequestLogin => _isLogin.sink;

  Stream<bool> get loginStatus$ => _isLoginValue.stream;


  var logger = Logger();


  Stream<bool> _getToken (){
    return Stream.fromFuture(sl<TokenStatusService>().getTokenStatus());
  }
  Stream<String> _getTokenValue (){
    return Stream.fromFuture(sl<TokenStatusService>().getToken());
  }
  Stream<String> _setToken (String token){
    return Stream.fromFuture(sl<TokenStatusService>().setToken(token));
  }
  void dispose() {
    _isLogin.close();
    _isLoginValue.close();
  }

}