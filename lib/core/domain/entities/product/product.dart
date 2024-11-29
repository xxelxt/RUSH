import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: 'product_id')
  String productId;

  @JsonKey(name: 'product_name')
  String productName;

  @JsonKey(name: 'product_price')
  double productPrice;

  @JsonKey(name: 'product_description')
  String productDescription;

  @JsonKey(name: 'product_image')
  List<String> productImage;

  @JsonKey(name: 'total_reviews')
  int totalReviews;

  @JsonKey(name: 'rating')
  double rating;

  @JsonKey(name: 'stock')
  int stock;

  @JsonKey(name: 'is_deleted')
  bool isDeleted;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  Product({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.productImage,
    required this.totalReviews,
    required this.rating,
    required this.stock,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
