import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address extends Equatable {
  @JsonKey(name: 'address_id')
  final String addressId;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'address')
  final String address;

  @JsonKey(name: 'city')
  final String city;

  @JsonKey(name: 'zip_code')
  final String zipCode;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Address({
    required this.addressId,
    required this.name,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  List<Object?> get props => [addressId];
}
