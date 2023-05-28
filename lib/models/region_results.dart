// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import 'cities_model.dart';

class RegionResults extends Equatable {
  RegionResults({required this.id, required this.name, required this.cities});

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

  late int id;
  late String name;
  late List<Cities> cities;

  @override
  List<Object> get props => [id, name];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    // ignore: unnecessary_null_comparison
    if (cities != null) {
      data['cities'] = cities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
