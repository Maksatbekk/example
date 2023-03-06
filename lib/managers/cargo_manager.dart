// ignore_for_file: lines_longer_than_80_chars, unused_import

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:onoy_kg/models/cargo.dart';
import 'package:onoy_kg/models/cities_model.dart';
import 'package:onoy_kg/models/region_results.dart';
import 'package:onoy_kg/models/regions_model.dart';
import 'package:onoy_kg/models/results.dart';
import 'package:onoy_kg/services/cargo_service.dart';
import 'package:onoy_kg/ui/helpers/request_command.dart';
import 'package:rxdart/rxdart.dart';

import '../service_locator.dart';

class CargoManager {
  CargoManager() {
    final logger = Logger();

    _requestSubject.listen((value) {
    //  logger.d(value);
      _getCargoData(value).listen((event) {
      //  logger.d(event);
        _cargoSubject.add(event);
      });

      _getRegions().listen((event) {
       /* logger.d('Regions');
        logger.d(event);*/
        _regionsSubject.add(event);
      });
    });

    _requestTransportSubject.listen((value) {
      logger.d(value);

      _getTransportationData(value).listen((event) {
         logger.d(event);
        _transportationSubject.add(event);
      });
      _getRegions().listen((event) {
        /* logger.d('Regions');
        logger.d(event);*/
        _regionsTSubject.add(event);
      });

    });

    _cargoCreateSubject.listen((value) {
      logger.d(value.fromRegion);
      _createCargo(value).listen((event) {
        _statusResponseSubject.add(event);
        logger.d(event);
      });
    });

    _cargoTransportSubject.listen((value) {
      logger.d(value);
      _createTransport(value).listen((event) {
        _statusResponseSubject.add(event);
        logger.d(event);
      });
    });


  }

  final PublishSubject<Results> _requestSubject = PublishSubject<Results>();
  final PublishSubject<Results> _requestTransportSubject = PublishSubject<Results>();
  final BehaviorSubject<Cargo> _cargoSubject = BehaviorSubject<Cargo>();
  final BehaviorSubject<Cargo> _transportationSubject = BehaviorSubject<Cargo>();
  final BehaviorSubject<Regions> _regionsSubject = BehaviorSubject<Regions>();
  final BehaviorSubject<Regions> _regionsTSubject = BehaviorSubject<Regions>();

  final BehaviorSubject<RegionResults> _regionSelectedSubject = BehaviorSubject<RegionResults>();
  final BehaviorSubject<RegionResults> _regionSelectedToSubject = BehaviorSubject<RegionResults>();
  final BehaviorSubject<List<Cities>> _regionSelectedCitiesSubject = BehaviorSubject<List<Cities>>();
  final BehaviorSubject<List<Cities>> _regionSelectedCitiesToSubject = BehaviorSubject<List<Cities>>();
  final PublishSubject<Cities> _selectedCitySubject = PublishSubject<Cities>();
  final PublishSubject<Cities> _selectedCityToSubject = PublishSubject<Cities>();

  final BehaviorSubject<RegionResults> _regionTSelectedSubject = BehaviorSubject<RegionResults>();
  final BehaviorSubject<RegionResults> _regionTSelectedToSubject = BehaviorSubject<RegionResults>();
  final BehaviorSubject<List<Cities>> _regionTSelectedCitiesSubject = BehaviorSubject<List<Cities>>();
  final BehaviorSubject<List<Cities>> _regionTSelectedCitiesToSubject = BehaviorSubject<List<Cities>>();
  final PublishSubject<Cities> _selectedTCitySubject = PublishSubject<Cities>();
  final PublishSubject<Cities> _selectedTCityToSubject = PublishSubject<Cities>();




  final BehaviorSubject<Results> _cargoCreateSubject = BehaviorSubject<Results>();
  final BehaviorSubject<Results> _cargoTransportSubject = BehaviorSubject<Results>();
  final PublishSubject<Response> _statusResponseSubject = PublishSubject<Response>();

  Sink<Results> get inRequest => _requestSubject.sink;


  Sink<Results> get inRequestTransportGet => _requestTransportSubject.sink;


  Sink<Results> get inRequestCargo => _cargoCreateSubject.sink;

  Sink<Results> get inRequestTransport => _cargoTransportSubject.sink;

  Stream<Cargo> get cargoList$ => _cargoSubject.stream;

  Stream<Cargo> get transportationList$ => _transportationSubject.stream;

  Stream<Regions> get regionsList$ => _regionsSubject.stream;
  Stream<Regions> get regionsTList$ => _regionsTSubject.stream;

  Sink<RegionResults> get inRegionSelected$ => _regionSelectedSubject.sink;
  Stream<RegionResults> get regionSelected$ => _regionSelectedSubject.stream;

  Sink<RegionResults> get inRegionTSelected$ => _regionTSelectedSubject.sink;
  Stream<RegionResults> get regionTSelected$ => _regionTSelectedSubject.stream;

  Sink<RegionResults> get inRegionToSelected$ => _regionSelectedToSubject.sink;
  Stream<RegionResults> get regionToSelected$ => _regionSelectedToSubject.stream;

  Sink<RegionResults> get inTRegionToSelected$ => _regionTSelectedToSubject.sink;
  Stream<RegionResults> get tregionToSelected$ => _regionTSelectedToSubject.stream;

  Sink<List<Cities>> get inCitySelected$ => _regionSelectedCitiesSubject.sink;
  Stream<List<Cities>> get citySelected$ => _regionSelectedCitiesSubject.stream;

  Sink<List<Cities>> get inCityTSelected$ => _regionSelectedCitiesSubject.sink;
  Stream<List<Cities>> get cityTSelected$ => _regionSelectedCitiesSubject.stream;

  Sink<List<Cities>> get inCityToSelected$ => _regionSelectedCitiesToSubject.sink;
  Stream<List<Cities>> get cityToSelected$ => _regionSelectedCitiesToSubject.stream;

  Sink<List<Cities>> get inTCityToSelected$ => _regionSelectedCitiesToSubject.sink;
  Stream<List<Cities>> get tcityToSelected$ => _regionSelectedCitiesToSubject.stream;

  Sink<Cities> get inCitySelect$ => _selectedCitySubject.sink;
  Stream<Cities> get citySelect$ => _selectedCitySubject.stream;

  Sink<Cities> get inTCitySelect$ => _selectedCitySubject.sink;
  Stream<Cities> get cityTSelect$ => _selectedCitySubject.stream;

  Sink<Cities> get inCityToSelect$ => _selectedCityToSubject.sink;
  Stream<Cities> get cityToSelect$ => _selectedCityToSubject.stream;

  Sink<Cities> get inTCityToSelect$ => _selectedCityToSubject.sink;
  Stream<Cities> get tcityToSelect$ => _selectedCityToSubject.stream;

  Stream<Response> get statusResponse$ => _statusResponseSubject.stream;

  Stream<Cargo> _getCargoData(Results query) {
    return Stream.fromFuture(sl<CargoService>().getCargo(query));
  }

  Stream<Cargo> _getTransportationData(Results query) {
    return Stream.fromFuture(sl<CargoService>().getTransportation(query));
  }

  Stream<Regions> _getRegions() {
    return Stream.fromFuture(sl<CargoService>().getRegions());
  }

  Stream<Response> _createCargo(Results cargo) {
    return Stream.fromFuture(sl<CargoService>().createCargo(cargo));
  }

  Stream<Response> _createTransport(Results cargo) {
    return Stream.fromFuture(sl<CargoService>().createTransport(cargo));
  }

  void dispose() {
    _requestSubject.close();
    _cargoSubject.close();
    _transportationSubject.close();
    _regionsSubject.close();
    _regionSelectedSubject.close();
    _regionSelectedCitiesSubject.close();
    _regionSelectedToSubject.close();
    _regionSelectedCitiesToSubject.close();
    _selectedCitySubject.close();
    _selectedCityToSubject.close();
    _requestTransportSubject.close();
    _regionsTSubject.close();
    _regionTSelectedSubject.close();
    _regionTSelectedToSubject.close();
    _regionTSelectedCitiesSubject.close();
    _regionTSelectedCitiesToSubject.close();
    _selectedTCitySubject.close();
    _selectedTCityToSubject.close();
  }
}
