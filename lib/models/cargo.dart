import 'package:onoy_kg/models/results.dart';

class Cargo {
  Cargo({this.count, this.next, this.previous, this.results});

  Cargo.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results.add(Results.fromJson(v));
      });
    }
  }

  int count;
  int next;
  int previous;
  List<Results> results;

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
