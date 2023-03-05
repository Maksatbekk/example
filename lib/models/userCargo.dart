class UserCargo {
  String name;
  String surname;
  String phoneNumber;
  String userType;

  UserCargo({this.name, this.surname, this.phoneNumber, this.userType});

  UserCargo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    phoneNumber = json['phone_number'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['surname'] = surname;
    data['phone_number'] = phoneNumber;
    data['user_type'] = userType;
    return data;
  }
}