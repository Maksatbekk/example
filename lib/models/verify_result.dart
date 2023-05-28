class VerifyResult {
  VerifyResult(
      {required this.idToken,
      required this.refreshToken,
      required this.expiresIn,
      required this.localId,
      required this.isNewUser,
      required this.phoneNumber,
      required this.message});

  VerifyResult.fromJson(Map<String, dynamic> json) {
    idToken = json['idToken'];
    refreshToken = json['refreshToken'];
    expiresIn = json['expiresIn'];
    localId = json['localId'];
    isNewUser = json['isNewUser'];
    phoneNumber = json['phoneNumber'];
    message = json['message'];
  }

  late String idToken;
  late String refreshToken;
  late String expiresIn;
  late String localId;
  late bool isNewUser;
  late String phoneNumber;
  late String message;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idToken'] = idToken;
    data['refreshToken'] = refreshToken;
    data['expiresIn'] = expiresIn;
    data['localId'] = localId;
    data['isNewUser'] = isNewUser;
    data['phoneNumber'] = phoneNumber;
    data['message'] = message;
    return data;
  }
}
