class Driver {
  Driver({
    required this.name,
    required this.surname,
    required this.region,
    required this.city,
    required this.type,
    required this.volume,
    required this.comment,
    required this.numbers,
  });

  String name;
  String surname;
  String region;
  String city;
  String type;
  late String capacity;
  String volume;
  String comment;
  List<String> numbers;
}
