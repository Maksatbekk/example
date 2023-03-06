import 'package:onoy_kg/models/users/vehicle_types_results.dart';

class VehicleTypes {

  VehicleTypes.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <VehicleTypesResult>[];
      json['results'].forEach((v) {
        results.add( VehicleTypesResult.fromJson(v));
      });
    }
  }

  VehicleTypes({this.count, this.next, this.previous, this.results});
  int count;
  int next;
  int previous;
  List<VehicleTypesResult> results;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
