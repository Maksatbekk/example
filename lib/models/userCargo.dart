// ignore_for_file: lines_longer_than_80_chars

class UserCargo {

  UserCargo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    phoneNumber = json['phone_number'];
    userType = json['user_type'];
  }

  UserCargo({required this.name, required this.surname, required this.phoneNumber, required this.userType});
  late String name;
  late String surname;
  late String phoneNumber;
  late String userType;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['surname'] = surname;
    data['phone_number'] = phoneNumber;
    data['user_type'] = userType;
    return data;
  }
}