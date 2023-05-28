import 'package:onoy_kg/models/results.dart';

class Cargo {
  // ignore: lines_longer_than_80_chars
  Cargo({required this.count, required this.next, required this.previous, required this.results});

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

  late int count;
  late int next;
  late int previous;
  late List<Results> results;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    // ignore: unnecessary_null_comparison
    if (results != null) {
      data['results'] = results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
