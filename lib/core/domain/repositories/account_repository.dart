import 'package:rush/core/domain/entities/account/account.dart';

abstract class AccountRepository {
  Future<Account?> getAccountProfile({required String accountId});

  Future<List<Account>> getAllAccount();

  Future<void> banAccount({required String accountId, required bool ban});

  Future<void> updateAccount({required String accountId, required Map<String, dynamic> data});
}
