import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class AuthManager {
  AuthManager() {
    _buttonClicked.listen((value) {
      logger.d(value);
    });
  }

  final BehaviorSubject<String> _buttonClicked = BehaviorSubject<String>();

  Sink<String> get inRequestToggle => _buttonClicked.sink;

  Stream<String> get currentSelection$ => _buttonClicked.stream;

  var logger = Logger();

  void dispose() {
    _buttonClicked.close();
  }
}
