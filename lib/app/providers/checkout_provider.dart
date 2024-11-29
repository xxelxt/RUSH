import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/core/domain/entities/product/product.dart';
import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:rush/core/domain/usecases/cart/delete_account_cart.dart';
import 'package:rush/core/domain/usecases/checkout/pay.dart';
import 'package:rush/core/domain/usecases/checkout/start_checkout.dart';
import 'package:rush/core/domain/usecases/product/update_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/domain/entities/account/account.dart';
import '../../core/domain/entities/cart/cart.dart';

class CheckoutProvider with ChangeNotifier {
  final StartCheckout startCheckout;
  final Pay pay;
  final UpdateProduct updateProduct;
  final DeleteAccountCart deleteAccountCart;

  CheckoutProvider({
    required this.startCheckout,
    required this.pay,
    required this.updateProduct,
    required this.deleteAccountCart,
  });

  // Loading State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late Transaction _dataTransaction;
  Transaction get dataTransaction => _dataTransaction;
  set setTransaction(Transaction data) => _dataTransaction = data;

  int _countItems = 0;
  int get countItems => _countItems;

  start({required List<Cart> cart, required Account account}) {
    _countItems = 0;
    _dataTransaction = startCheckout.execute(cart: cart, account: account);
    for (var element in cart) {
      _countItems += element.quantity;
    }
  }

  Future<void> payCheckout() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Insert data to Transaction
      _dataTransaction.createdAt = DateTime.now();
      _dataTransaction.updatedAt = DateTime.now();
      await pay.execute(data: _dataTransaction);

      String accountId = FirebaseAuth.instance.currentUser!.uid;

      // Subtract product stock & remove cart
      await Future.forEach(_dataTransaction.purchasedProduct, (Cart element) async {
        Product temp = element.product!;

        temp.stock -= element.quantity;
        if (temp.stock < 0) temp.stock = 0;

        await updateProduct.execute(data: temp);
        await deleteAccountCart.execute(accountId: accountId, cartId: element.cartId);
      });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Pay Error: ${e.toString()}');
      notifyListeners();
    }
  }

  updateTotalBill({required Address? shippingAddress}) {
    if (shippingAddress != null) {
      dataTransaction.totalBill = dataTransaction.shippingFee! + dataTransaction.totalPrice!;
    } else {
      dataTransaction.totalBill = null;
    }
  }
}
