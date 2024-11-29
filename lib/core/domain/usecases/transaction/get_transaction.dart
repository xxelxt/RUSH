import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:rush/core/domain/repositories/transaction_repository.dart';

class GetTransaction {
  final TransactionRepository _repository;

  GetTransaction(this._repository);

  Future<Transaction?> execute({required String transactionId}) async {
    return await _repository.getTransaction(
      transactionId: transactionId,
    );
  }
}
