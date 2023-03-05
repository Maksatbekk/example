class VehicleTypesResult {
  int id;
  String name;

  VehicleTypesResult({this.id, this.name});

  VehicleTypesResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}