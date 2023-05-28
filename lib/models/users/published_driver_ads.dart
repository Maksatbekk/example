// ignore_for_file: lines_longer_than_80_chars

import 'package:onoy_kg/models/users/pda_results.dart';

class PublishedAdds {
  PublishedAdds({required this.count, required this.next, required this.previous, required this.results});

  PublishedAdds.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <PDAResults>[];
      json['results'].forEach((v) {
        results.add(PDAResults.fromJson(v));
      });
    }
  }
  late int count;
  late int next;
  late int previous;
  late List<PDAResults> results;

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
