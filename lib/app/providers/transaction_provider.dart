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

  // Loading State
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool _isLoadingDetail = true;
  bool get isLoadingDetail => _isLoadingDetail;

  // List Transaction
  List<Transaction> _listTransaction = [];
  List<Transaction> get listTransaction => _listTransaction;

  // Detail Transaction
  Transaction? _detailTransaction;
  Transaction? get detailTransaction => _detailTransaction;

  // Count Items
  int _countItems = 0;
  int get countItems => _countItems;

  loadAccountTransaction({
    String search = '',
    OrderByEnum orderByEnum = OrderByEnum.newest,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      _listTransaction.clear();

      String accountId = FirebaseAuth.instance.currentUser!.uid;

      var response = await getAccountTransaction.execute(accountId: accountId);

      if (response.isNotEmpty) {
        _listTransaction = response;
        sortList(orderByEnum);
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

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Load Account Transaction Error: ${e.toString()}');
      notifyListeners();
    }
  }

  loadDetailTransaction({required String transactionId}) async {
    try {
      _isLoadingDetail = true;
      notifyListeners();

      var response = await getTransaction.execute(transactionId: transactionId);

      if (response != null) {
        _detailTransaction = response;
        _countItems = 0;

        if (FlavorConfig.isAdmin()) {
          if (_detailTransaction!.account == null) {
            var data = await getAccountProfile.execute(accountId: _detailTransaction!.accountId);
            _detailTransaction!.account = data;
          }
        }

        for (var element in _detailTransaction!.purchasedProduct) {
          _countItems += element.quantity;
        }
      }

      _isLoadingDetail = false;
      notifyListeners();
    } catch (e) {
      _isLoadingDetail = false;
      debugPrint('Load Detail Transaction Error: ${e.toString()}');
      notifyListeners();
    }
  }

  loadAllTransaction({
    String search = '',
    OrderByEnum orderByEnum = OrderByEnum.newest,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      var response = await getAllTransaction.execute();

      if (response.isNotEmpty) {
        _listTransaction = response;

        await Future.forEach<Transaction>(_listTransaction, (element) async {
          if (element.account == null) {
            var data = await getAccountProfile.execute(accountId: element.accountId);
            element.account = data;
          }
        });

        sortList(orderByEnum);
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

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Load Account Transaction Error: ${e.toString()}');
      notifyListeners();
    }
  }

  accept() async {
    try {
      _isLoading = true;
      notifyListeners();

      await acceptTransaction.execute(data: _detailTransaction!);
      await loadDetailTransaction(transactionId: _detailTransaction!.transactionId);
      loadAccountTransaction();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Accept Transaction Error: ${e.toString()}');
      notifyListeners();
    }
  }

  Future<void> submitReview({required String transactionId, required List<Review> data}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await Future.forEach(data, (Review review) async {
        await addReview.execute(
          transactionId: transactionId,
          data: review,
        );
      });

      await changeStatus(transactionID: transactionId, status: TransactionStatus.reviewed.value);
      await loadDetailTransaction(transactionId: transactionId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Submit Review Error: ${e.toString()}');
      notifyListeners();
    }
  }

  changeStatus({required String transactionID, required int status}) async {
    try {
      _isLoadingDetail = true;
      notifyListeners();

      await changeTransactionStatus.execute(transactionID: transactionID, status: status);
      await loadDetailTransaction(transactionId: transactionID);
      loadAllTransaction();
    } catch (e) {
      _isLoadingDetail = false;
      debugPrint('Change Transaction Status Error: ${e.toString()}');
      notifyListeners();
    }
  }

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
