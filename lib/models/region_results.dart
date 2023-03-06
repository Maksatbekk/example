// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import 'cities_model.dart';

class RegionResults extends Equatable {
  RegionResults({this.id, this.name, this.cities});

  RegionResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities.add(Cities.fromJson(v));
      });
    }
  }

  int id;
  String name;
  List<Cities> cities;

  @override
  List<Object> get props => [id, name];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (cities != null) {
      data['cities'] = cities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
