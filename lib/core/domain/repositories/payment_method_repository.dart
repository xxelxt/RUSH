import 'package:rush/core/domain/entities/payment_method/payment_method.dart';

abstract class PaymentMethodRepository {
  Future<List<PaymentMethod>> getAccountPaymentMethod({required String accountId});

  Future<void> addPaymentMethod({required String accountId, required PaymentMethod data});

  Future<void> updatePaymentMethod({required String accountId, required PaymentMethod data});

  Future<void> deletePaymentMethod({required String accountId, required String paymentMethodId});

  Future<void> changePrimaryPaymentMethod({required String accountId, required PaymentMethod paymentMethod});
}
