// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wishlist _$WishlistFromJson(Map<String, dynamic> json) => Wishlist(
      wishlistId: json['wishlist_id'] as String,
      productId: json['product_id'] as String,
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$WishlistToJson(Wishlist instance) => <String, dynamic>{
      'wishlist_id': instance.wishlistId,
      'product': instance.product?.toJson(),
      'product_id': instance.productId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
