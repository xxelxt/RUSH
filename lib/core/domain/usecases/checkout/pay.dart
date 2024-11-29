import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:rush/core/domain/repositories/checkout_repository.dart';

class Pay {
  final CheckoutRepository _repository;

  Pay(this._repository);

  Future<void> execute({required Transaction data}) async {
    return await _repository.pay(data: data);
  }
}
