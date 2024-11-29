import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_method.g.dart';

@JsonSerializable()
class PaymentMethod extends Equatable {
  @JsonKey(name: 'payment_method_id')
  final String paymentMethodId;

  @JsonKey(name: 'card_number')
  final String cardNumber;

  @JsonKey(name: 'cardholder_name')
  final String cardholderName;

  @JsonKey(name: 'expiry_date')
  final String expiryDate;

  @JsonKey(name: 'cvv')
  final String cvv;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const PaymentMethod({
    required this.paymentMethodId,
    required this.cardNumber,
    required this.cardholderName,
    required this.expiryDate,
    required this.cvv,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);

  @override
  List<Object?> get props => [paymentMethodId];
}
