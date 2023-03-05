
import '../user.dart';

class PDAResults {
   PDAResults(
      {this.id,
        this.name,
        this.user,
        this.fromShipmentDate,
        this.toShipmentDate,
        this.fromRegion,
        this.fromCity,
        this.toRegion,
        this.toCity,
        this.datePublished,
        this.vehicleComment,
        this.price,
        this.weight});

  PDAResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    user = json['user'] != null ?  UserModel.fromJson(json['user']) : null;
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

   int id;
   String name;
   UserModel user;
   String fromShipmentDate;
   String toShipmentDate;
   String fromRegion;
   String fromCity;
   String toRegion;
   String toCity;
   String datePublished;
   String vehicleComment;
   int price;
   int weight;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
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