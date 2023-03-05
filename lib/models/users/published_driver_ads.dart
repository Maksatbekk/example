import 'package:onoy_kg/models/users/pda_results.dart';

class PublishedAdds {
  PublishedAdds({this.count, this.next, this.previous, this.results});

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
  int count;
  int next;
  int previous;
  List<PDAResults> results;

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
