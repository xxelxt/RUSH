import 'package:rush/core/domain/repositories/account_repository.dart';

class BanAccount {
  final AccountRepository _repository;

  BanAccount(this._repository);

  Future<void> execute({required String accountId, required bool ban}) async {
    return _repository.banAccount(accountId: accountId, ban: ban);
  }
}
