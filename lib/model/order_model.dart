class OrderModel {
  int? id;
  String? serviceName;
  String? resiCode;
  String? status;
  double? totalPrice;
  String? createdAt;

  OrderModel({this.id, this.serviceName, this.resiCode, this.status, this.totalPrice, this.createdAt});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: int.tryParse(json['id'].toString()),
      serviceName: json['service_name'],
      resiCode: json['resi_code'],
      status: json['status'],
      totalPrice: double.tryParse(json['total_price'].toString()),
      createdAt: json['created_at'],
    );
  }
}