import 'package:rush/app/constants/order_by_value.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:rush/core/domain/entities/review/review.dart';
import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:rush/core/domain/usecases/account/get_account_profile.dart';
import 'package:rush/core/domain/usecases/transaction/accept_transaction.dart';
import 'package:rush/core/domain/usecases/transaction/add_review.dart';
import 'package:rush/core/domain/usecases/transaction/change_transaction_status.dart';
import 'package:rush/core/domain/usecases/transaction/get_account_transaction.dart';
import 'package:rush/core/domain/usecases/transaction/get_all_transaction.dart';
import 'package:rush/core/domain/usecases/transaction/get_transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Sử dụng `ChangeNotifier` để quản lý trạng thái và xử lý giao dịch
class TransactionProvider with ChangeNotifier {
  final GetAccountTransaction getAccountTransaction;
  final GetTransaction getTransaction;
  final GetAllTransaction getAllTransaction;
  final AcceptTransaction acceptTransaction;
  final AddReview addReview;
  final ChangeTransactionStatus changeTransactionStatus;
  final GetAccountProfile getAccountProfile;

  TransactionProvider({
    required this.getAccountTransaction,
    required this.getTransaction,
    required this.getAllTransaction,
    required this.acceptTransaction,
    required this.addReview,
    required this.changeTransactionStatus,
    required this.getAccountProfile,
  });

  // Trạng thái tải dữ liệu
  bool _isLoading = true; // Trạng thái chung
  bool get isLoading => _isLoading;

  bool _isLoadingDetail = true; // Trạng thái chi tiết giao dịch
  bool get isLoadingDetail => _isLoadingDetail;

  // Danh sách giao dịch
  List<Transaction> _listTransaction = [];
  List<Transaction> get listTransaction => _listTransaction;

  // Chi tiết giao dịch
  Transaction? _detailTransaction;
  Transaction? get detailTransaction => _detailTransaction;

  // Đếm số lượng sản phẩm
  int _countItems = 0;
  int get countItems => _countItems;

  // Tải danh sách giao dịch của tài khoản
  loadAccountTransaction({
    String search = '',
    OrderByEnum orderByEnum = OrderByEnum.newest,
  }) async {
    try {
      _isLoading = true; // Đặt trạng thái đang tải
      notifyListeners();
      _listTransaction.clear(); // Xoá danh sách cũ

      String accountId = FirebaseAuth.instance.currentUser!.uid; // Lấy ID tài khoản hiện tại

      // Gọi usecase để lấy danh sách giao dịch
      var response = await getAccountTransaction.execute(accountId: accountId);

      if (response.isNotEmpty) {
        _listTransaction = response; // Cập nhật danh sách
        sortList(orderByEnum); // Sắp xếp danh sách

        // Lọc danh sách theo từ khoá tìm kiếm
        if (search.isNotEmpty) {
          _listTransaction = _listTransaction
              .where(
                (element) => element.purchasedProduct.any(
                  (cart) => cart.product!.productName.toLowerCase().contains(search.toLowerCase()),
            ),
          )
              .toList();
        }
      }

      _isLoading = false; // Hoàn thành tải dữ liệu
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Dừng trạng thái tải khi lỗi xảy ra
      debugPrint('Lỗi khi tải thanh toán: ${e.toString()}');
      notifyListeners();
    }
  }

  // Tải chi tiết một giao dịch
  loadDetailTransaction({required String transactionId}) async {
    try {
      _isLoadingDetail = true;
      notifyListeners();

      // Gọi usecase để lấy chi tiết giao dịch
      var response = await getTransaction.execute(transactionId: transactionId);

      if (response != null) {
        _detailTransaction = response; // Lưu thông tin chi tiết giao dịch
        _countItems = 0;

        // Lấy thông tin tài khoản liên quan đến giao dịch (nếu là admin)
        if (FlavorConfig.isAdmin()) {
          if (_detailTransaction!.account == null) {
            var data = await getAccountProfile.execute(accountId: _detailTransaction!.accountId);
            _detailTransaction!.account = data;
          }
        }

        // Đếm số lượng sản phẩm trong giao dịch
        for (var element in _detailTransaction!.purchasedProduct) {
          _countItems += element.quantity;
        }
      }

      _isLoadingDetail = false; // Hoàn thành tải chi tiết
      notifyListeners();
    } catch (e) {
      _isLoadingDetail = false; // Dừng trạng thái tải khi lỗi xảy ra
      debugPrint('Lỗi khi tải chi tiết thanh toán hoá đơn: ${e.toString()}');
      notifyListeners();
    }
  }

  // Tải tất cả giao dịch
  loadAllTransaction({
    String search = '',
    OrderByEnum orderByEnum = OrderByEnum.newest,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gọi usecase để lấy tất cả giao dịch
      var response = await getAllTransaction.execute();

      if (response.isNotEmpty) {
        _listTransaction = response;

        // Lấy thông tin tài khoản liên quan đến từng giao dịch nếu chưa có
        await Future.forEach<Transaction>(_listTransaction, (element) async {
          if (element.account == null) {
            var data = await getAccountProfile.execute(accountId: element.accountId);
            element.account = data;
          }
        });

        sortList(orderByEnum); // Sắp xếp danh sách

        // Lọc danh sách theo từ khoá tìm kiếm
        if (search.isNotEmpty) {
          _listTransaction = _listTransaction
              .where(
                (element) => element.purchasedProduct.any(
                  (cart) => cart.product!.productName.toLowerCase().contains(search.toLowerCase()),
            ),
          )
              .toList();
        }
      }

      _isLoading = false; // Hoàn thành tải dữ liệu
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Dừng trạng thái tải khi lỗi xảy ra
      debugPrint('Lỗi khi tải thanh toán: ${e.toString()}');
      notifyListeners();
    }
  }

  // Chấp nhận giao dịch
  accept() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gọi usecase để chấp nhận giao dịch
      await acceptTransaction.execute(data: _detailTransaction!);
      await loadDetailTransaction(transactionId: _detailTransaction!.transactionId); // Tải lại chi tiết giao dịch
      loadAccountTransaction(); // Cập nhật danh sách giao dịch

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Dừng trạng thái tải khi lỗi xảy ra
      debugPrint('Lỗi thanh toán: ${e.toString()}');
      notifyListeners();
    }
  }

  // Gửi đánh giá
  Future<void> submitReview({required String transactionId, required List<Review> data}) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gửi đánh giá cho từng sản phẩm
      await Future.forEach(data, (Review review) async {
        await addReview.execute(
          transactionId: transactionId,
          data: review,
        );
      });

      // Cập nhật trạng thái giao dịch thành "đã đánh giá"
      await changeStatus(transactionID: transactionId, status: TransactionStatus.reviewed.value);
      await loadDetailTransaction(transactionId: transactionId); // Tải lại chi tiết giao dịch

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Dừng trạng thái tải khi lỗi xảy ra
      debugPrint('Lỗi gửi đánh giá: ${e.toString()}');
      notifyListeners();
    }
  }

  // Thay đổi trạng thái giao dịch
  changeStatus({required String transactionID, required int status}) async {
    try {
      _isLoadingDetail = true;
      notifyListeners();

      // Gọi usecase để thay đổi trạng thái
      await changeTransactionStatus.execute(transactionID: transactionID, status: status);
      await loadDetailTransaction(transactionId: transactionID); // Tải lại chi tiết giao dịch
      loadAllTransaction(); // Cập nhật danh sách giao dịch
    } catch (e) {
      _isLoadingDetail = false;
      debugPrint('Lỗi cập nhật trạng thái đơn hàng: ${e.toString()}');
      notifyListeners();
    }
  }

  // Sắp xếp danh sách giao dịch
  sortList(OrderByEnum data) {
    switch (data) {
      case OrderByEnum.newest:
        listTransaction.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        break;
      case OrderByEnum.oldest:
        listTransaction.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        break;
      case OrderByEnum.cheapest:
        listTransaction.sort((a, b) => a.totalPay!.compareTo(b.totalPay!));
        break;
      case OrderByEnum.mostExpensive:
        listTransaction.sort((a, b) => b.totalPay!.compareTo(a.totalPay!));
        break;
      default:
        listTransaction.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        break;
    }
  }
}
