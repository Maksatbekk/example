import 'package:onoy_kg/models/user.dart';

class Results {

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromRegion = json['from_region'];
    fromCity = json['from_city'];
    toRegion = json['to_region'];
    toCity = json['to_city'];
    datePublished = json['date_published'];
    fromPlaceComment = json['from_place_comment'];
    toPlaceComment = json['to_place_comment'];
    cargoComment = json['cargo_comment'];
    vehicleComment = json['vehicle_comment'];
    fromShipmentDate = json['from_shipment_date'];
    toShipmentDate = json['to_shipment_date'];
    name = json['name'];
    weight = json['weight'];
    height = json['height'];
    length = json['length'];
   // volume = json['volume'];
    width = json['width'];
    phoneNumber = json['phone_number'];
    whatsappNumber = json['whatsapp_number'];
    telegramNumber = json['telegram_number'];
    price = json['price'];
    senderName = json['sender_name'];
    senderSurname = json['sender_surname'];
    user = json['user'] != null ?  UserModel.fromJson(json['user']) : null;
  }

  Results(
      {this.id,
        this.fromRegion,
        this.fromCity,
        this.toRegion,
        this.toCity,
        this.datePublished,
        this.fromPlaceComment,
        this.toPlaceComment,
        this.cargoComment,
        this.vehicleComment,
        this.fromShipmentDate,
        this.toShipmentDate,
        this.name,
        this.weight,
        this.height,
        this.length,
        //this.volume,
        this.phoneNumber,
        this.whatsappNumber,
        this.telegramNumber,
        this.price,
        this.senderName,
        this.senderSurname,
        this.user,
        this.weightFrom,
        this.weightTo,
        this.priceFrom,
        this.priceTo,

      });
  int id;
  String fromRegion;
  String fromCity;
  String toRegion;
  String toCity;
  String datePublished;
  String fromPlaceComment;
  String toPlaceComment;
  String cargoComment;
  String vehicleComment;
  String fromShipmentDate;
  String toShipmentDate;
  String name;
  dynamic weight;
  String height;
  String length;
 // dynamic volume;
  String width;
  String phoneNumber;
  String whatsappNumber;
  String telegramNumber;
  dynamic price;
  String senderName;
  String senderSurname;
  UserModel user;
  String weightFrom;
  String weightTo;
  String priceFrom;
  String priceTo;

  Map<String, dynamic> toJson() {
    final data =  <String, dynamic>{};
    data['id'] = id;
    data['from_region'] = fromRegion;
    data['from_city'] = fromCity;
    data['to_region'] = toRegion;
    data['to_city'] = toCity;
    data['date_published'] = datePublished;
    data['from_place_comment'] = fromPlaceComment;
    data['to_place_comment'] = toPlaceComment;
    data['cargo_comment'] = cargoComment;
    data['from_shipment_date'] = fromShipmentDate;
    data['to_shipment_date'] = toShipmentDate;
    data['name'] = name;
    data['weight'] = weight;
    data['height'] = height;
    data['length'] = length;
   // data['volume'] = volume;
    data['width'] = width;
    data['phone_number'] = phoneNumber;
    data['whatsapp_number'] = whatsappNumber;
    data['telegram_number'] = telegramNumber;
    data['price'] = price;
    data['sender_name'] = senderName;
    data['sender_surname'] = senderSurname;
    if (user != null) {
      data['user'] = user.toJson();
    }
    return data;
  }
}