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

  // Trạng thái tải dữ liệu
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Danh sách phương thức thanh toán
  List<PaymentMethod> _listPaymentMethod = [];
  List<PaymentMethod> get listPaymentMethod => _listPaymentMethod;

  // Thêm phương thức thanh toán mới
  Future<void> add({
    required String accountId,
    required PaymentMethod data, // Thông tin phương thức thanh toán
  }) async {
    try {
      _isLoading = true; // Đặt trạng thái đang tải
      notifyListeners();

      // Gọi usecase để thêm phương thức thanh toán
      await addPaymentMethod.execute(accountId: accountId, data: data);
      _listPaymentMethod.add(data); // Thêm vào danh sách hiện tại

      _isLoading = false; // Hoàn thành
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Ngừng nếu xảy ra lỗi
      debugPrint('Lỗi khi thêm phương thức thanh toán: ${e.toString()}');
      notifyListeners();
    }
  }

  // Lấy danh sách phương thức thanh toán của tài khoản
  getPaymentMethod({required String accountId}) async {
    try {
      _isLoading = true;
      notifyListeners();
      _listPaymentMethod.clear(); // Xoá danh sách cũ trước khi tải mới

      // Gọi usecase để lấy danh sách phương thức thanh toán
      var response = await getAccountPaymentMethod.execute(accountId: accountId);

      if (response.isNotEmpty) {
        _listPaymentMethod = response; // Cập nhật danh sách
      }

      _isLoading = false; // Hoàn thành
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Lỗi khi lấy thông tin phương thức thanh toán: ${e.toString()}');
      notifyListeners();
    }
  }

  // Cập nhật thông tin phương thức thanh toán
  Future<void> update({
    required String accountId,
    required PaymentMethod data, // Thông tin mới của phương thức thanh toán
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gọi usecase để cập nhật phương thức thanh toán
      await updatePaymentMethod.execute(accountId: accountId, data: data);

      // Tìm và cập nhật thông tin trong danh sách hiện tại
      int index = listPaymentMethod.indexWhere((element) => element.paymentMethodId == data.paymentMethodId);
      listPaymentMethod[index] = data;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Ngừng nếu xảy ra lỗi
      debugPrint('Lỗi khi cập nhật phương thức thanh toán: ${e.toString()}');
      notifyListeners();
    }
  }

  // Xoá phương thức thanh toán
  delete({
    required String accountId,
    required String paymentMethodId,
  }) async {
    try {
      // Gọi usecase để xoá phương thức thanh toán
      await deletePaymentMethod.execute(accountId: accountId, paymentMethodId: paymentMethodId);

      // Loại bỏ phương thức khỏi danh sách hiện tại
      listPaymentMethod.removeWhere((element) => element.paymentMethodId == paymentMethodId);

      notifyListeners(); // Thông báo cập nhật UI
    } catch (e) {
      debugPrint('Lỗi khi xoá phương thức thanh toán: ${e.toString()}');
      notifyListeners();
    }
  }

  // Thay đổi phương thức thanh toán mặc định
  Future<void> changePrimary({
    required String accountId,
    required PaymentMethod data, // Phương thức thanh toán mới cần đặt làm mặc định
    required PaymentMethod? oldData, // Phương thức thanh toán hiện tại (nếu có)
  }) async {
    // Kiểm tra nếu phương thức mới trùng với phương thức hiện tại thì không cần thay đổi
    if (oldData != null && oldData == data) return;

    try {
      // Gọi usecase để thay đổi phương thức thanh toán mặc định
      await changePrimaryPaymentMethod.execute(accountId: accountId, paymentMethod: data);
    } catch (e) {
      debugPrint('Lỗi khi thay đổi phương thức thanh toán mặc định: ${e.toString()}');
    }
  }
}
