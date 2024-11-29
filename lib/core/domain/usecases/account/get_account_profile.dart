import 'package:rush/core/domain/entities/account/account.dart';
import 'package:rush/core/domain/repositories/account_repository.dart';

class GetAccountProfile {
  final AccountRepository _repository;

  GetAccountProfile(this._repository);

  Future<Account?> execute({required String accountId}) async {
    return _repository.getAccountProfile(accountId: accountId);
  }
}
