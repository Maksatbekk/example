class Cities {
  Cities({this.id, this.name});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  int id;
  String name;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
