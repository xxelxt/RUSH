import 'package:rush/core/domain/entities/account/account.dart';
import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/core/domain/entities/cart/cart.dart';
import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable(explicitToJson: true)
class Transaction {
  @JsonKey(name: 'transaction_id')
  String transactionId;

  @JsonKey(name: 'account_id')
  String accountId;

  @JsonKey(name: 'account')
  Account? account;

  @JsonKey(name: 'shipping_address')
  Address? shippingAddress;

  @JsonKey(name: 'purchased_product')
  List<Cart> purchasedProduct;

  @JsonKey(name: 'sub_total')
  double? subTotal = 0;

  @JsonKey(name: 'total_price')
  double? totalPrice = 0;

  @JsonKey(name: 'shipping_fee')
  double? shippingFee = 0;

  @JsonKey(name: 'payment_method')
  PaymentMethod? paymentMethod;

  @JsonKey(name: 'total_bill')
  double? totalBill = 0;

  @JsonKey(name: 'service_fee')
  double? serviceFee = 0;

  @JsonKey(name: 'total_pay')
  double? totalPay = 0;

  @JsonKey(name: 'transaction_status')
  int? transactionStatus = 0; // 0: Processed, 1: Sent, 2: Arrived, 3: Done, 4: Cancelled

  @JsonKey(name: 'created_at')
  DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;

  Transaction({
    required this.transactionId,
    required this.accountId,
    required this.purchasedProduct,
    this.account,
    this.shippingAddress,
    this.subTotal,
    this.totalPrice,
    this.shippingFee,
    this.paymentMethod,
    this.totalBill,
    this.serviceFee,
    this.totalPay,
    this.transactionStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

enum TransactionStatus {
  processed(0),
  sent(1),
  arrived(2),
  done(3),
  rejected(4),
  reviewed(5);

  final int value;
  const TransactionStatus(this.value);
}
