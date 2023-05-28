class Create {
  Create({required this.refresh, required this.access});

  Create.fromJson(Map<String, dynamic> json) {
    refresh = json['refresh'];
    access = json['access'];
  }

  late String refresh;
  late String access;


  Map<String, dynamic> toJson() {
    final data =  <String, dynamic>{};
    data['refresh'] = refresh;
    data['access'] = access;
    return data;
  }
}