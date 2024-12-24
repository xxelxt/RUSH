// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      reviewId: json['review_id'] as String,
      productId: json['product_id'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      accountId: json['account_id'] as String,
      star: (json['star'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      reviewerName: json['reviewer_name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'review_id': instance.reviewId,
      'product_id': instance.productId,
      'product': instance.product.toJson(),
      'account_id': instance.accountId,
      'reviewer_name': instance.reviewerName,
      'star': instance.star,
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
