class VerifyResult {
  VerifyResult(
      {this.idToken,
      this.refreshToken,
      this.expiresIn,
      this.localId,
      this.isNewUser,
      this.phoneNumber,
      this.message});

  VerifyResult.fromJson(Map<String, dynamic> json) {
    idToken = json['idToken'];
    refreshToken = json['refreshToken'];
    expiresIn = json['expiresIn'];
    localId = json['localId'];
    isNewUser = json['isNewUser'];
    phoneNumber = json['phoneNumber'];
    message = json['message'];
  }

  String idToken;
  String refreshToken;
  String expiresIn;
  String localId;
  bool isNewUser;
  String phoneNumber;
  String message;

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
