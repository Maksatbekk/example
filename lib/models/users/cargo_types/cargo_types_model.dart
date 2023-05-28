// ignore_for_file: unnecessary_getters_setters

import 'cargo_types_result.dart';

class CargoTypes {
  CargoTypes.fromJson(Map<String, dynamic> json) {
    _count = json['count'];
    _next = json['next'];
    _previous = json['previous'];
    if (json['results'] != null) {
      _results = <CargoTypesResults>[];
      json['results'].forEach((v) {
        _results.add(CargoTypesResults.fromJson(v));
      });
    }
  }
  CargoTypes({
    required int count,
    required int next,
    required int previous,
    required List<CargoTypesResults> results,
  }) {
    _count = count;
    _next = next;
    _previous = previous;
    _results = results;
  }

  late int _count;
  late int _next;
  late int _previous;
  late List<CargoTypesResults> _results;

  int get count => _count;

  set count(int count) => _count = count;

  int get next => _next;

  set next(int next) => _next = next;

  int get previous => _previous;

  set previous(int previous) => _previous = previous; 

  List<CargoTypesResults> get results => _results;

  set results(List<CargoTypesResults> results) => _results = results;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['count'] = _count;
    data['next'] = _next;
    data['previous'] = _previous;
    // ignore: unnecessary_null_comparison
    if (_results != null) {
      data['results'] = _results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
