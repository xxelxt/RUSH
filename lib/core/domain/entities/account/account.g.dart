// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      accountId: json['account_id'] as String,
      fullName: json['full_name'] as String,
      emailAddress: json['email_address'] as String,
      phoneNumber: json['phone_number'] as String,
      role: (json['role'] as num).toInt(),
      banStatus: json['ban_status'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      primaryPaymentMethod: json['primary_payment_method'] == null
          ? null
          : PaymentMethod.fromJson(
              json['primary_payment_method'] as Map<String, dynamic>),
      primaryAddress: json['primary_address'] == null
          ? null
          : Address.fromJson(json['primary_address'] as Map<String, dynamic>),
      photoProfileUrl: json['photo_profile_url'] as String,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'account_id': instance.accountId,
      'full_name': instance.fullName,
      'email_address': instance.emailAddress,
      'phone_number': instance.phoneNumber,
      'role': instance.role,
      'ban_status': instance.banStatus,
      'primary_payment_method': instance.primaryPaymentMethod,
      'primary_address': instance.primaryAddress,
      'photo_profile_url': instance.photoProfileUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
