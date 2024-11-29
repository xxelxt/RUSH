import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/add_payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/change_primary_payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/delete_payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/get_account_payment_method.dart';
import 'package:rush/core/domain/usecases/payment_method/update_payment_method.dart';
import 'package:flutter/material.dart';

class PaymentMethodProvider with ChangeNotifier {
  final AddPaymentMethod addPaymentMethod;
  final GetAccountPaymentMethod getAccountPaymentMethod;
  final UpdatePaymentMethod updatePaymentMethod;
  final DeletePaymentMethod deletePaymentMethod;
  final ChangePrimaryPaymentMethod changePrimaryPaymentMethod;

  PaymentMethodProvider({
    required this.addPaymentMethod,
    required this.getAccountPaymentMethod,
    required this.updatePaymentMethod,
    required this.deletePaymentMethod,
    required this.changePrimaryPaymentMethod,
  });

  // Loading State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // List Payment Method
  List<PaymentMethod> _listPaymentMethod = [];
  List<PaymentMethod> get listPaymentMethod => _listPaymentMethod;

  Future<void> add({
    required String accountId,
    required PaymentMethod data,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await addPaymentMethod.execute(accountId: accountId, data: data);
      _listPaymentMethod.add(data);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Add Payment Method Error: ${e.toString()}');
      notifyListeners();
    }
  }

  getPaymentMethod({required String accountId}) async {
    try {
      _isLoading = true;
      notifyListeners();
      _listPaymentMethod.clear();

      var response = await getAccountPaymentMethod.execute(accountId: accountId);

      if (response.isNotEmpty) {
        _listPaymentMethod = response;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Get Payment Method Error: ${e.toString()}');
      notifyListeners();
    }
  }

  Future<void> update({
    required String accountId,
    required PaymentMethod data,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await updatePaymentMethod.execute(accountId: accountId, data: data);
      int index = listPaymentMethod.indexWhere((element) => element.paymentMethodId == data.paymentMethodId);
      listPaymentMethod[index] = data;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Update Payment Method Error: ${e.toString()}');
      notifyListeners();
    }
  }

  delete({
    required String accountId,
    required String paymentMethodId,
  }) async {
    try {
      await deletePaymentMethod.execute(accountId: accountId, paymentMethodId: paymentMethodId);
      listPaymentMethod.removeWhere((element) => element.paymentMethodId == paymentMethodId);

      notifyListeners();
    } catch (e) {
      debugPrint('Delete Payment Method Error: ${e.toString()}');
      notifyListeners();
    }
  }

  Future<void> changePrimary({
    required String accountId,
    required PaymentMethod data,
    required PaymentMethod? oldData,
  }) async {
    if (oldData != null && oldData == data) return;

    try {
      await changePrimaryPaymentMethod.execute(accountId: accountId, paymentMethod: data);
    } catch (e) {
      debugPrint('Change Primary Payment Method Error: ${e.toString()}');
    }
  }
}
