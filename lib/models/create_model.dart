class Create {
  Create({this.refresh, this.access});

  Create.fromJson(Map<String, dynamic> json) {
    refresh = json['refresh'];
    access = json['access'];
  }

  String refresh;
  String access;



  Map<String, dynamic> toJson() {
    final data =  <String, dynamic>{};
    data['refresh'] = refresh;
    data['access'] = access;
    return data;
  }
}