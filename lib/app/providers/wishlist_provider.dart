import 'package:rush/app/constants/order_by_value.dart';
import 'package:rush/core/domain/entities/wishlist/wishlist.dart';
import 'package:rush/core/domain/usecases/product/get_product.dart';
import 'package:rush/core/domain/usecases/wishlist/add_account_wishlist.dart';
import 'package:rush/core/domain/usecases/wishlist/delete_account_wishlist.dart';
import 'package:rush/core/domain/usecases/wishlist/get_account_wishlist.dart';
import 'package:flutter/cupertino.dart';

class WishlistProvider with ChangeNotifier {
  final AddAccountWishlist addAccountWishlist;
  final GetAccountWishlist getAccountWishlist;
  final DeleteAccountWishlist deleteAccountWishlist;
  final GetProduct getProduct;

  WishlistProvider({
    required this.addAccountWishlist,
    required this.getAccountWishlist,
    required this.deleteAccountWishlist,
    required this.getProduct,
  });

  // Load State
  bool _isLoadData = true;
  bool get isLoadData => _isLoadData;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // List Wishlist
  List<Wishlist> _listWishlist = [];
  List<Wishlist> get listWishlist => _listWishlist;

  loadWishlist({
    required String accountId,
    String search = '',
    OrderByEnum orderByEnum = OrderByEnum.newest,
  }) async {
    try {
      _isLoadData = true;
      notifyListeners();
      _listWishlist.clear();

      var response = await getAccountWishlist.execute(
        accountId: accountId,
        search: search,
      );

      if (response.isNotEmpty) {
        _listWishlist = response;
        await Future.forEach<Wishlist>(_listWishlist, (element) async {
          if (element.product == null) {
            var dataProduct = await getProduct.execute(productId: element.productId);
            element.product = dataProduct;
          }
        });
        sortList(orderByEnum);
        if (search.isNotEmpty) {
          _listWishlist = _listWishlist
              .where((element) => element.product!.productName.toLowerCase().contains(search.toLowerCase()))
              .toList();
        }
      }

      _isLoadData = false;
      notifyListeners();
    } catch (e) {
      _isLoadData = false;
      debugPrint('Load Wishlist Error: ${e.toString()}');
      notifyListeners();
    }
  }

  add({required String accountId, required Wishlist data}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await addAccountWishlist.execute(accountId: accountId, data: data);

      var dataProduct = await getProduct.execute(productId: data.productId);
      data.product = dataProduct;
      listWishlist.add(data);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Add Wishlist Error: ${e.toString()}');
      notifyListeners();
    }
  }

  delete({required String accountId, required String wishlistId}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await deleteAccountWishlist.execute(accountId: accountId, wishlistId: wishlistId);
      listWishlist.removeWhere((element) => element.wishlistId == wishlistId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Add Wishlist Error: ${e.toString()}');
      notifyListeners();
    }
  }

  sortList(OrderByEnum data) {
    switch (data) {
      case OrderByEnum.newest:
        listWishlist.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case OrderByEnum.oldest:
        listWishlist.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case OrderByEnum.cheapest:
        listWishlist.sort((a, b) => a.product!.productPrice.compareTo(b.product!.productPrice));
        break;
      case OrderByEnum.mostExpensive:
        listWishlist.sort((a, b) => b.product!.productPrice.compareTo(a.product!.productPrice));
        break;
      default:
        listWishlist.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
  }
}
