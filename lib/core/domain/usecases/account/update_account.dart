import 'package:rush/core/domain/repositories/account_repository.dart';

class UpdateAccount {
  final AccountRepository _repository;

  UpdateAccount(this._repository);

  Future<void> execute({required String accountId, required Map<String, dynamic> data}) async {
    return _repository.updateAccount(accountId: accountId, data: data);
  }
}
