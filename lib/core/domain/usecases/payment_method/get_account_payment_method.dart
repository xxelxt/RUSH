import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:rush/core/domain/repositories/payment_method_repository.dart';

class GetAccountPaymentMethod {
  final PaymentMethodRepository _repository;

  GetAccountPaymentMethod(this._repository);

  Future<List<PaymentMethod>> execute({required String accountId}) async {
    return await _repository.getAccountPaymentMethod(accountId: accountId);
  }
}
