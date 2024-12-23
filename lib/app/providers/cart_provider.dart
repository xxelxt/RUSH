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

  // Trạng thái tải dữ liệu
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _firstLoad = true; // Flag kiểm tra lần tải đầu tiên
  bool get firstLoad => _firstLoad;

  // Danh sách sản phẩm trong giỏ hàng
  List<Cart> _listCart = [];
  List<Cart> get listCart => _listCart;

  int countCart = 0;
  double total = 0;

  // Thêm sản phẩm vào giỏ hàng
  Future<void> addCart({
    required String accountId,
    required Cart data, // Dữ liệu sản phẩm cần thêm
  }) async {
    try {
      _isLoading = true; // Bắt đầu trạng thái tải
      notifyListeners();

      // Gọi usecase để thêm sản phẩm vào giỏ hàng
      await addAccountCart.execute(accountId: accountId, data: data);

      listCart.add(data); // Thêm sản phẩm vào danh sách giỏ hàng

      countCarts(); // Cập nhật số lượng và tổng tiền

      _isLoading = false; // Hoàn thành trạng thái tải
      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi khi thêm sản phẩm vào giỏ hàng: ${e.toString()}');
      _isLoading = false; // Dừng trạng thái tải nếu xảy ra lỗi
      notifyListeners();
    }
  }

  // Lấy danh sách sản phẩm trong giỏ hàng
  getCart({required String accountId}) async {
    _firstLoad = true; // Đặt flag lần tải đầu tiên
    notifyListeners();

    try {
      // Gọi usecase để lấy danh sách sản phẩm trong giỏ hàng
      var response = await getAccountCart.execute(accountId: accountId);
      countCart = 0;
      _listCart.clear(); // Xoá danh sách cũ trước khi tải mới

      if (response.isNotEmpty) {
        _listCart = response; // Cập nhật danh sách giỏ hàng
        await Future.forEach<Cart>(_listCart, (element) async {
          // Lấy thông tin chi tiết sản phẩm từ ID sản phẩm
          var dataProduct = await getProduct.execute(productId: element.productId);
          element.product = dataProduct;
        });
        countCarts(); // Cập nhật số lượng và tổng tiền
      }

      _firstLoad = false; // Đặt flag hoàn thành tải
      notifyListeners();
    } catch (e) {
      _firstLoad = false; // Dừng trạng thái tải nếu xảy ra lỗi
      debugPrint('Lỗi khi lấy thông tin giỏ hàng: ${e.toString()}');
      notifyListeners();
    }
  }

  // Cập nhật sản phẩm trong giỏ hàng
  updateCart({
    required Cart data, // Dữ liệu sản phẩm cần cập nhật
  }) {
    try {
      _isLoading = true;
      notifyListeners();

      String accountId = FirebaseAuth.instance.currentUser!.uid; // Lấy ID người dùng hiện tại

      // Tìm sản phẩm trong danh sách giỏ hàng
      int cartIndex = listCart.indexWhere((element) => element.cartId == data.cartId);

      if (listCart[cartIndex].quantity == 0) {
        // Nếu số lượng bằng 0, xoá sản phẩm khỏi giỏ hàng
        deleteCart(accountId: accountId, cartId: listCart[cartIndex].cartId);
        listCart.removeAt(cartIndex);
      } else {
        // Cập nhật số lượng sản phẩm
        listCart[cartIndex] = data;
        updateAccountCart.execute(accountId: accountId, data: data); // Gọi usecase để cập nhật
      }

      countCarts(); // Cập nhật số lượng và tổng tiền

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi khi cập nhật sản phẩm trong giỏ hàng: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Xoá sản phẩm khỏi giỏ hàng
  deleteCart({
    required String accountId, // ID tài khoản người dùng
    required String cartId, // ID sản phẩm trong giỏ hàng
  }) {
    try {
      // Gọi usecase để xoá sản phẩm khỏi giỏ hàng
      deleteAccountCart.execute(accountId: accountId, cartId: cartId);
    } catch (e) {
      debugPrint('Lỗi khi xoá sản phẩm trong giỏ hàng: ${e.toString()}');
    }
  }

  // Tính tổng số lượng sản phẩm và tổng tiền
  countCarts() {
    countCart = 0; // Đặt lại số lượng
    total = 0; // Đặt lại tổng tiền
    for (var element in listCart) {
      countCart += element.quantity; // Cộng dồn số lượng sản phẩm
      total += element.quantity * element.product!.productPrice; // Tính tổng tiền
    }
  }
}
