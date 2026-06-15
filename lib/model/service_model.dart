class ServiceModel {
  String name;
  double price;
  String desc;

  ServiceModel({required this.name, required this.price, required this.desc});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      name: json['name'],
      price: double.parse(json['price'].toString()),
      desc: json['desc'],
    );
  }
}