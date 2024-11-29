import 'package:rush/core/domain/entities/address/address.dart';

abstract class AddressRepository {
  Future<List<Address>> getAccountAddress({required String accountId});

  Future<void> addAddress({required String accountId, required Address data});

  Future<void> updateAddress({required String accountId, required Address data});

  Future<void> deleteAddress({required String accountId, required String addressId});

  Future<void> changePrimaryAddress({required String accountId, required Address address});
}
