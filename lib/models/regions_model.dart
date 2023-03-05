import 'package:onoy_kg/models/region_results.dart';

class Regions {
  Regions({this.count, this.next, this.previous, this.results});

  Regions.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <RegionResults>[];
      json['results'].forEach((v) {
        results.add(RegionResults.fromJson(v));
      });
    }
  }

  int count;
  int next;
  int previous;
  List<RegionResults> results;

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
