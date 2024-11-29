import 'package:json_annotation/json_annotation.dart';

import '../product/product.dart';

part 'cart.g.dart';

@JsonSerializable(explicitToJson: true)
class Cart {
  @JsonKey(name: 'cart_id')
  String cartId;

  @JsonKey(name: 'product_id')
  String productId;

  @JsonKey(name: 'product')
  Product? product;

  @JsonKey(name: 'quantity')
  int quantity;

  @JsonKey(name: 'total')
  double total;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  Cart({
    required this.cartId,
    required this.productId,
    this.product,
    required this.quantity,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);
}
