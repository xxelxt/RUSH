import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/core/domain/repositories/address_repository.dart';

class AddAddress {
  final AddressRepository _repository;

  AddAddress(this._repository);

  Future<void> execute({required String accountId, required Address data}) async {
    return await _repository.addAddress(accountId: accountId, data: data);
  }
}
