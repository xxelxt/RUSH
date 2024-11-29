import 'package:rush/core/domain/entities/account/account.dart';
import 'package:rush/core/domain/repositories/account_repository.dart';

class GetAllAccount {
  final AccountRepository _repository;

  GetAllAccount(this._repository);

  Future<List<Account>> execute() async {
    return _repository.getAllAccount();
  }
}
