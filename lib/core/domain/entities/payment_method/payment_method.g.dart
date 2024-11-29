// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      paymentMethodId: json['payment_method_id'] as String,
      cardNumber: json['card_number'] as String,
      cardholderName: json['cardholder_name'] as String,
      expiryDate: json['expiry_date'] as String,
      cvv: json['cvv'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'payment_method_id': instance.paymentMethodId,
      'card_number': instance.cardNumber,
      'cardholder_name': instance.cardholderName,
      'expiry_date': instance.expiryDate,
      'cvv': instance.cvv,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
