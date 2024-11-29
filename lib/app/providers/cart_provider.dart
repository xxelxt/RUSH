import 'package:rush/core/domain/entities/cart/cart.dart';
import 'package:rush/core/domain/usecases/cart/add_account_cart.dart';
import 'package:rush/core/domain/usecases/cart/delete_account_cart.dart';
import 'package:rush/core/domain/usecases/cart/get_account_cart.dart';
import 'package:rush/core/domain/usecases/cart/update_account_cart.dart';
import 'package:rush/core/domain/usecases/product/get_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final AddAccountCart addAccountCart;
  final GetAccountCart getAccountCart;
  final UpdateAccountCart updateAccountCart;
  final DeleteAccountCart deleteAccountCart;
  final GetProduct getProduct;

  CartProvider({
    required this.addAccountCart,
    required this.getAccountCart,
    required this.updateAccountCart,
    required this.deleteAccountCart,
    required this.getProduct,
  });

  // Loading State
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _firstLoad = true;
  bool get firstLoad => _firstLoad;

  // List Cart
  List<Cart> _listCart = [];
  List<Cart> get listCart => _listCart;

  // Count Cart
  int countCart = 0;
  double total = 0;

  Future<void> addCart({
    required String accountId,
    required Cart data,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await addAccountCart.execute(accountId: accountId, data: data);

      listCart.add(data);

      countCarts();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Add Cart Error: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
    }
  }

  getCart({required String accountId}) async {
    _firstLoad = true;
    notifyListeners();

    try {
      var response = await getAccountCart.execute(accountId: accountId);
      countCart = 0;
      _listCart.clear();

      if (response.isNotEmpty) {
        _listCart = response;
        await Future.forEach<Cart>(_listCart, (element) async {
          var dataProduct = await getProduct.execute(productId: element.productId);
          element.product = dataProduct;
        });
        countCarts();
      }

      _firstLoad = false;
      notifyListeners();
    } catch (e) {
      _firstLoad = false;
      debugPrint('Get Cart Error: ${e.toString()}');
      notifyListeners();
    }
  }

  updateCart({
    required Cart data,
  }) {
    try {
      _isLoading = true;
      notifyListeners();

      String accountId = FirebaseAuth.instance.currentUser!.uid;

      int cartIndex = listCart.indexWhere((element) => element.cartId == data.cartId);

      if (listCart[cartIndex].quantity == 0) {
        deleteCart(accountId: accountId, cartId: listCart[cartIndex].cartId);
        listCart.removeAt(cartIndex);
      } else {
        listCart[cartIndex] = data;
        updateAccountCart.execute(accountId: accountId, data: data);
      }

      countCarts();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Update Cart Error: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
    }
  }

  deleteCart({
    required String accountId,
    required String cartId,
  }) {
    try {
      deleteAccountCart.execute(accountId: accountId, cartId: cartId);
    } catch (e) {
      debugPrint('Delete Cart Error: ${e.toString()}');
    }
  }

  countCarts() {
    countCart = 0;
    total = 0;
    for (var element in listCart) {
      countCart += element.quantity;
      total += element.quantity * element.product!.productPrice;
    }
  }
}
