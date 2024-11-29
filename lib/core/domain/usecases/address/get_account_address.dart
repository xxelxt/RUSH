import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/core/domain/repositories/address_repository.dart';

class GetAccountAddress {
  final AddressRepository _repository;

  GetAccountAddress(this._repository);

  Future<List<Address>> execute({required String accountId}) async {
    return await _repository.getAccountAddress(accountId: accountId);
  }
}
