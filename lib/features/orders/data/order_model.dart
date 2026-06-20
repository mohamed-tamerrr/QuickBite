/// Send To Backend
class OrderItemRequest {
  final int productId;
  final int quantity;
  final double spicy;
  final List<int> toppings;
  final List<int> sideOptions;

  OrderItemRequest({
    required this.productId,
    required this.quantity,
    required this.spicy,
    required this.toppings,
    required this.sideOptions,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'spicy': spicy,
      'toppings': toppings,
      'side_options': sideOptions,
    };
  }
}

class OrderRequest {
  final List<OrderItemRequest> items;

  OrderRequest({required this.items});

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((items) => items.toJson()).toList(),
    };
  }
}

/// Get From Backend
class OrdersResponse {
  int? code;
  String? message;
  List<Order>? data;

  OrdersResponse({this.code, this.message, this.data});

  OrdersResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Order>[];
      json['data'].forEach((v) {
        data!.add(Order.fromJson(v));
      });
    }
  }
}

class Order {
  int? id;
  String? status;
  String? totalPrice;
  String? createdAt;
  String? productImage;

  Order({
    this.id,
    this.status,
    this.totalPrice,
    this.createdAt,
    this.productImage,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    productImage = json['product_image'];
  }
}
