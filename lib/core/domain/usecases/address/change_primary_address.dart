import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/core/domain/repositories/address_repository.dart';

class ChangePrimaryAddress {
  final AddressRepository _repository;

  ChangePrimaryAddress(this._repository);

  Future<void> execute({required String accountId, required Address data}) async {
    return await _repository.changePrimaryAddress(accountId: accountId, address: data);
  }
}
