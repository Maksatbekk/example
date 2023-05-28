class UserModel {
  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    password = json['password'];
    userType = json['user_type'];
    phoneNumber = json['phone_number'];
    uidToken = json['uid_token'];
    id = json['id'];
    checked = json['checked'];
    registered = json['registered'];
  }

  UserModel({
    this.name,
    this.surname,
    this.password,
    this.userType,
    this.phoneNumber,
    this.uidToken,
    this.id,
    this.checked,
    this.registered,
  });
  String? name;
  String? surname;
  String? password;
  String? userType;
  String? phoneNumber;
  String? uidToken;
  int? id;
  bool? checked;
  bool? registered;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['surname'] = surname;
    data['password'] = password;
    data['user_type'] = userType;
    data['phone_number'] = phoneNumber;
    data['uid_token'] = uidToken;
    data['id'] = id;
    data['checked'] = checked;
    data['registered'] = registered;
    return data;
  }
}
