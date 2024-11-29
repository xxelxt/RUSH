import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  @JsonKey(name: 'account_id')
  String accountId;

  @JsonKey(name: 'full_name')
  String fullName;

  @JsonKey(name: 'email_address')
  String emailAddress;

  @JsonKey(name: 'phone_number')
  String phoneNumber;

  @JsonKey(name: 'role')
  int role;

  @JsonKey(name: 'ban_status')
  bool banStatus;

  @JsonKey(name: 'primary_payment_method')
  PaymentMethod? primaryPaymentMethod;

  @JsonKey(name: 'primary_address')
  Address? primaryAddress;

  @JsonKey(name: 'photo_profile_url')
  String photoProfileUrl;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  Account({
    required this.accountId,
    required this.fullName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.role,
    required this.banStatus,
    required this.createdAt,
    required this.updatedAt,
    this.primaryPaymentMethod,
    this.primaryAddress,
    required this.photoProfileUrl,
  });

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
