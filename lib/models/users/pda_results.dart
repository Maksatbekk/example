import '../user.dart';

class PDAResults {
  PDAResults({
    required this.id,
    required this.name,
    required this.user,
    required this.fromShipmentDate,
    required this.toShipmentDate,
    required this.fromRegion,
    required this.fromCity,
    required this.toRegion,
    required this.toCity,
    required this.datePublished,
    required this.vehicleComment,
    required this.price,
    required this.weight,
  }) {
    // TODO: implement PDAResults
    throw UnimplementedError();
  }

  PDAResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    user = (json['user'] != null ? UserModel.fromJson(json['user']) : null)!;
    fromShipmentDate = json['from_shipment_date'];
    toShipmentDate = json['to_shipment_date'];
    fromRegion = json['from_region'];
    fromCity = json['from_city'];
    toRegion = json['to_region'];
    toCity = json['to_city'];
    datePublished = json['date_published'];
    vehicleComment = json['vehicle_comment'];
    price = json['price'];
    weight = json['weight'];
  }

  late int id;
  late String name;
  late UserModel user;
  late String fromShipmentDate;
  late String toShipmentDate;
  late String fromRegion;
  late String fromCity;
  late String toRegion;
  late String toCity;
  late String datePublished;
  late String vehicleComment;
  late int price;
  late int weight;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    // ignore: unnecessary_null_comparison
    if (user != null) {
      data['user'] = user.toJson();
    }
    data['from_shipment_date'] = fromShipmentDate;
    data['to_shipment_date'] = toShipmentDate;
    data['from_region'] = fromRegion;
    data['from_city'] = fromCity;
    data['to_region'] = toRegion;
    data['to_city'] = toCity;
    data['date_published'] = datePublished;
    data['vehicle_comment'] = vehicleComment;
    data['price'] = price;
    data['weight'] = weight;
    return data;
  }
}
