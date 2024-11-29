import 'package:rush/core/domain/repositories/address_repository.dart';

class DeleteAddress {
  final AddressRepository _repository;

  DeleteAddress(this._repository);

  Future<void> execute({required String accountId, required String addressId}) async {
    return await _repository.deleteAddress(accountId: accountId, addressId: addressId);
  }
}
