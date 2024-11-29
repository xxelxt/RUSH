import 'package:rush/core/domain/repositories/transaction_repository.dart';

class ChangeTransactionStatus {
  final TransactionRepository _repository;

  ChangeTransactionStatus(this._repository);

  Future<void> execute({required String transactionID, required int status}) async {
    return await _repository.changeTransactionStatus(transactionID: transactionID, status: status);
  }
}
