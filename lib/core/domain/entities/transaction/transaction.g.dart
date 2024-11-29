// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      transactionId: json['transaction_id'] as String,
      accountId: json['account_id'] as String,
      purchasedProduct: (json['purchased_product'] as List<dynamic>)
          .map((e) => Cart.fromJson(e as Map<String, dynamic>))
          .toList(),
      account: json['account'] == null
          ? null
          : Account.fromJson(json['account'] as Map<String, dynamic>),
      shippingAddress: json['shipping_address'] == null
          ? null
          : Address.fromJson(json['shipping_address'] as Map<String, dynamic>),
      subTotal: (json['sub_total'] as num?)?.toDouble(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      shippingFee: (json['shipping_fee'] as num?)?.toDouble(),
      paymentMethod: json['payment_method'] == null
          ? null
          : PaymentMethod.fromJson(
              json['payment_method'] as Map<String, dynamic>),
      totalBill: (json['total_bill'] as num?)?.toDouble(),
      serviceFee: (json['service_fee'] as num?)?.toDouble(),
      totalPay: (json['total_pay'] as num?)?.toDouble(),
      transactionStatus: json['transaction_status'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionId,
      'account_id': instance.accountId,
      'account': instance.account?.toJson(),
      'shipping_address': instance.shippingAddress?.toJson(),
      'purchased_product':
          instance.purchasedProduct.map((e) => e.toJson()).toList(),
      'sub_total': instance.subTotal,
      'total_price': instance.totalPrice,
      'shipping_fee': instance.shippingFee,
      'payment_method': instance.paymentMethod?.toJson(),
      'total_bill': instance.totalBill,
      'service_fee': instance.serviceFee,
      'total_pay': instance.totalPay,
      'transaction_status': instance.transactionStatus,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
