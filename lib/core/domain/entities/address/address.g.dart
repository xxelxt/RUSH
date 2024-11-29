// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      addressId: json['address_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      zipCode: json['zip_code'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'address_id': instance.addressId,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'zip_code': instance.zipCode,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
