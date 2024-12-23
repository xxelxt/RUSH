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

  // Trạng thái tải dữ liệu
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Dữ liệu giao dịch
  late Transaction _dataTransaction;
  Transaction get dataTransaction => _dataTransaction;
  set setTransaction(Transaction data) => _dataTransaction = data;

  // Tổng số lượng sản phẩm trong giao dịch
  int _countItems = 0;
  int get countItems => _countItems;

  // Bắt đầu quá trình thanh toán
  start({required List<Cart> cart, required Account account}) {
    _countItems = 0; // Đặt lại tổng số lượng sản phẩm

    // Gọi usecase để tạo dữ liệu giao dịch
    _dataTransaction = startCheckout.execute(cart: cart, account: account);

    // Tính tổng số lượng sản phẩm từ danh sách giỏ hàng
    for (var element in cart) {
      _countItems += element.quantity;
    }
  }

  // Xử lý thanh toán
  Future<void> payCheckout() async {
    try {
      _isLoading = true; // Bắt đầu trạng thái tải
      notifyListeners();

      // Thêm dữ liệu thời gian vào giao dịch
      _dataTransaction.createdAt = DateTime.now();
      _dataTransaction.updatedAt = DateTime.now();

      // Gọi usecase để xử lý thanh toán
      await pay.execute(data: _dataTransaction);

      String accountId = FirebaseAuth.instance.currentUser!.uid;

      // Trừ số lượng sản phẩm trong kho và xoá sản phẩm khỏi giỏ hàng
      await Future.forEach(_dataTransaction.purchasedProduct, (Cart element) async {
        Product temp = element.product!;

        // Cập nhật số lượng tồn kho
        temp.stock -= element.quantity;
        if (temp.stock < 0) temp.stock = 0;

        // Gọi usecase để cập nhật sản phẩm
        await updateProduct.execute(data: temp);

        // Gọi usecase để xoá sản phẩm khỏi giỏ hàng
        await deleteAccountCart.execute(accountId: accountId, cartId: element.cartId);
      });

      _isLoading = false; // Hoàn thành trạng thái tải
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Ngừng trạng thái tải khi lỗi xảy ra
      debugPrint('Lỗi khi thanh toán: ${e.toString()}');
      notifyListeners();
    }
  }

  // Cập nhật tổng tiền thanh toán (bao gồm phí vận chuyển)
  updateTotalBill({required Address? shippingAddress}) {
    if (shippingAddress != null) {
      // Nếu có địa chỉ giao hàng, tính tổng tiền
      dataTransaction.totalBill = dataTransaction.shippingFee! + dataTransaction.totalPrice!;
    } else {
      // Nếu không có địa chỉ giao hàng, tổng tiền là null
      dataTransaction.totalBill = null;
    }
  }
}
