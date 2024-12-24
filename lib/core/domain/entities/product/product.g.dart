// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      productPrice: (json['product_price'] as num).toDouble(),
      productDescription: json['product_description'] as String,
      productImage: (json['product_image'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalReviews: (json['total_reviews'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      isDeleted: json['is_deleted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'product_id': instance.productId,
      'product_name': instance.productName,
      'product_price': instance.productPrice,
      'product_description': instance.productDescription,
      'product_image': instance.productImage,
      'total_reviews': instance.totalReviews,
      'rating': instance.rating,
      'stock': instance.stock,
      'is_deleted': instance.isDeleted,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
