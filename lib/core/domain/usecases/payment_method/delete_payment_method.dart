import 'package:rush/core/domain/repositories/payment_method_repository.dart';

class DeletePaymentMethod {
  final PaymentMethodRepository _repository;

  DeletePaymentMethod(this._repository);

  Future<void> execute({required String accountId, required String paymentMethodId}) async {
    return await _repository.deletePaymentMethod(accountId: accountId, paymentMethodId: paymentMethodId);
  }
}
