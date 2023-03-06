// ignore_for_file: unused_import

import 'package:logger/logger.dart';
import 'package:onoy_kg/models/results.dart';
import 'package:onoy_kg/ui/helpers/request_command.dart';
import 'package:rxdart/rxdart.dart';

import '../service_locator.dart';
import 'cargo_manager.dart';

class MainManager {
  MainManager() {
    _toggleSelected.listen((value) async {
     // logger.d(value);
      //sl<CargoManager>().inRequest.add(RequestCommand.UPDATE);
      sl<CargoManager>().inRequest.add(value);
    });
  }

  final BehaviorSubject<Results> _toggleSelected = BehaviorSubject<Results>();
  final BehaviorSubject<int> _toggleSelectedMain = BehaviorSubject<int>();

  Sink<Results> get inRequestToggle => _toggleSelected.sink;

  Stream<Results> get currentSelection$ => _toggleSelected.stream;

  Stream<int> get currentSelectionMain$ => _toggleSelectedMain.stream;
  var logger = Logger();

  void dispose() {
    _toggleSelected.close();
    _toggleSelectedMain.close();
  }
}
