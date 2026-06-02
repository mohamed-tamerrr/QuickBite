/// send to backend
class CartModel {
  final int productId;
  final int qty;
  final double spicy;
  final List<int> toppings;
  final List<int> options;

  CartModel({
    required this.productId,
    required this.qty,
    required this.spicy,
    required this.toppings,
    required this.options,
  });

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'quantity': qty,
    'spicy': spicy,
    'toppings': toppings,
    'side_options': options,
  };
}

class CartRequestModel {
  final List<CartModel> items;

  CartRequestModel({required this.items});

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
  };
}

/// get from backend
class GetCartResponse {
  final int code;
  final String message;
  final CartData cartData;

  GetCartResponse({
    required this.code,
    required this.message,
    required this.cartData,
  });

  factory GetCartResponse.fromJson(Map<String, dynamic> json) {
    return GetCartResponse(
      code: json['code'] ?? 200,
      message: json['message']?.toString() ?? '',
      cartData: CartData.fromJson(json['data']),
    );
  }
}

class CartData {
  final int id;
  final String totalPrice;
  final List<CartItemModel> items;

  CartData({
    required this.id,
    required this.totalPrice,
    required this.items,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['id'] ?? 0,
      totalPrice: json['total_price']?.toString() ?? '0',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class CartItemModel {
  final int itemId;
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final String productPrice;
  final String spicyLevel;
  // final List<String> toppings;
  // final List<String> sideOptions;

  CartItemModel({
    required this.itemId,
    required this.productPrice,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.spicyLevel,
    // required this.toppings,
    // required this.sideOptions,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      itemId: json['item_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['name']?.toString() ?? '',
      productImage: json['image']?.toString() ?? '',
      quantity: json['quantity'] ?? 0,
      productPrice: json['price']?.toString() ?? '0',
      spicyLevel: json['spicy']?.toString() ?? '',
      // toppings:
      //     (json['toppings'] as List<dynamic>?)
      //         ?.map((topping) => topping.toString())
      //         .toList() ??
      //     [],
      // sideOptions:
      //     (json['side_options'] as List<dynamic>?)
      //         ?.map((option) => option.toString())
      //         .toList() ??
      //     [],
    );
  }
}
