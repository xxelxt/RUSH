import 'package:json_annotation/json_annotation.dart';

import '../product/product.dart';

part 'wishlist.g.dart';

@JsonSerializable(explicitToJson: true)
class Wishlist {
  @JsonKey(name: 'wishlist_id')
  String wishlistId;

  @JsonKey(name: 'product')
  Product? product;

  @JsonKey(name: 'product_id')
  String productId;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  Wishlist({
    required this.wishlistId,
    required this.productId,
    this.product,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) => _$WishlistFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistToJson(this);
}
