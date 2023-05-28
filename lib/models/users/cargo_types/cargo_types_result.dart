// ignore_for_file: must_be_immutable, unnecessary_getters_setters

import 'package:equatable/equatable.dart';

class CargoTypesResults extends Equatable {
  CargoTypesResults({required int id, required String name}) {
    _id = id;
    _name = name;
  }

  CargoTypesResults.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
  }

  @override
  List<Object> get props => [id, name];

  late int _id;
  late String _name;

  int get id => _id;

  set id(int id) => _id = id;

  String get name => _name;

  set name(String name) => _name = name;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    return data;
  }
}
