class VehicleTypesResult {

  VehicleTypesResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  VehicleTypesResult({required this.id, required this.name});
  late int id;
  late String name;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}