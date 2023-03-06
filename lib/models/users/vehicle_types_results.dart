class VehicleTypesResult {

  VehicleTypesResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  VehicleTypesResult({this.id, this.name});
  int id;
  String name;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}