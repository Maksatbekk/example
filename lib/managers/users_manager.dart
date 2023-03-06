// ignore_for_file: unused_import, duplicate_ignore

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:onoy_kg/models/cargo.dart';
import 'package:onoy_kg/models/users/cargo_types/cargo_types_model.dart';
import 'package:onoy_kg/models/users/register_driver_model.dart';
import 'package:onoy_kg/services/users_service.dart';
import 'package:onoy_kg/ui/helpers/request_command.dart';
import 'package:rxdart/rxdart.dart';

import '../service_locator.dart';

class UsersManager {
  UsersManager() {
    _requestSubject.listen((value) {
      _getPublishedAdds().listen((event) {
        _publishedAdds.add(event);
        logger.d(event.count);
      });
    });

    _cargoTypesSubject.listen((value) {
      _getCargoTypes().listen((event) {
        logger.d(event);
        _cargoTypes.add(event);
      });
    });

    _registerDriverSubject.listen((value) {
      logger.d(value);
      _registerDriver(value).listen((event) {
        logger.d(event);
        _registerDrivers.add(event);
      });
    });

  }

  final BehaviorSubject<Cargo> _publishedAdds = BehaviorSubject<Cargo>();
  final BehaviorSubject<CargoTypes> _cargoTypes =
  BehaviorSubject<CargoTypes>();
  final BehaviorSubject<int> _registerDrivers =
  BehaviorSubject<int>();
  // ignore: lines_longer_than_80_chars
  final PublishSubject<RequestCommand> _requestSubject = PublishSubject<RequestCommand>();
  // ignore: lines_longer_than_80_chars
  final PublishSubject<RequestCommand> _cargoTypesSubject = PublishSubject<RequestCommand>();
  final PublishSubject<RegisterDriver> _registerDriverSubject =
  PublishSubject<RegisterDriver>();

  var logger = Logger();

  Sink<RequestCommand> get inRequest => _requestSubject.sink;
  Sink<RequestCommand> get inCargoTypes => _cargoTypesSubject.sink;
  Sink<RegisterDriver> get inRegisterDriver => _registerDriverSubject.sink;

  Stream<Cargo> get publishedAdds$ => _publishedAdds.stream;
  Stream<CargoTypes> get cargoTypes$ => _cargoTypes.stream;
  Stream<int> get registerDriver$ => _registerDrivers.stream;

  Stream<Cargo> _getPublishedAdds() {
    return Stream.fromFuture(sl<UsersService>().getPublishedAdds());
  }

  Stream<CargoTypes> _getCargoTypes() {
    return Stream.fromFuture(sl<UsersService>().getCargoTypes());
  }

  Stream<int> _registerDriver(RegisterDriver registerDriver) {
    return Stream.fromFuture(sl<UsersService>().registerDriver(registerDriver));
  }

  void dispose() {
    _publishedAdds.close();
    _requestSubject.close();
    _cargoTypes.close();
    _cargoTypesSubject.close();
    _registerDriverSubject.close();
    _registerDrivers.close();
  }
}
