import 'package:rush/core/domain/entities/product/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable(explicitToJson: true)
class Review {
  @JsonKey(name: 'review_id')
  String reviewId;

  @JsonKey(name: 'product_id')
  String productId;

  @JsonKey(name: 'product')
  Product product;

  @JsonKey(name: 'account_id')
  String accountId;

  @JsonKey(name: 'reviewer_name')
  String reviewerName;

  @JsonKey(name: 'star')
  int star;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  Review({
    required this.reviewId,
    required this.productId,
    required this.product,
    required this.accountId,
    required this.star,
    required this.createdAt,
    required this.updatedAt,
    required this.reviewerName,
    this.description,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
