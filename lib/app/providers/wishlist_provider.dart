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

  // Trạng thái tải dữ liệu
  bool _isLoadData = true;
  bool get isLoadData => _isLoadData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Danh sách sản phẩm yêu thích
  List<Wishlist> _listWishlist = [];
  List<Wishlist> get listWishlist => _listWishlist;

  // Tải danh sách yêu thích
  loadWishlist({
    required String accountId,
    String search = '',
    OrderByEnum orderByEnum = OrderByEnum.newest,
  }) async {
    try {
      _isLoadData = true; // Bắt đầu tải dữ liệu
      notifyListeners();
      _listWishlist.clear(); // Xoá danh sách cũ trước khi tải mới

      // Gọi usecase để lấy danh sách yêu thích
      var response = await getAccountWishlist.execute(
        accountId: accountId,
        search: search,
      );

      if (response.isNotEmpty) {
        _listWishlist = response; // Lưu danh sách yêu thích
        // Lấy chi tiết sản phẩm nếu chưa có
        await Future.forEach<Wishlist>(_listWishlist, (element) async {
          if (element.product == null) {
            var dataProduct =
                await getProduct.execute(productId: element.productId);
            element.product = dataProduct;
          }
        });
        sortList(orderByEnum); // Sắp xếp danh sách

        // Lọc theo từ khoá tìm kiếm
        if (search.isNotEmpty) {
          _listWishlist = _listWishlist
              .where((element) => element.product!.productName
                  .toLowerCase()
                  .contains(search.toLowerCase()))
              .toList();
        }
      }

      _isLoadData = false; // Hoàn thành tải dữ liệu
      notifyListeners();
    } catch (e) {
      _isLoadData = false; // Ngừng trạng thái tải nếu lỗi xảy ra
      debugPrint('Lỗi tải danh sách yêu thích: ${e.toString()}');
      notifyListeners();
    }
  }

  // Thêm sản phẩm vào danh sách yêu thích
  add({required String accountId, required Wishlist data}) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gọi usecase để thêm sản phẩm vào danh sách yêu thích
      await addAccountWishlist.execute(accountId: accountId, data: data);

      // Lấy chi tiết sản phẩm và cập nhật vào danh sách
      var dataProduct = await getProduct.execute(productId: data.productId);
      data.product = dataProduct;
      listWishlist.add(data);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Ngừng trạng thái tải nếu lỗi xảy ra
      debugPrint('Lỗi thêm sản phẩm yêu thích: ${e.toString()}');
      notifyListeners();
    }
  }

  // Xoá sản phẩm khỏi danh sách yêu thích
  delete({required String accountId, required String wishlistId}) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gọi usecase để xoá sản phẩm
      await deleteAccountWishlist.execute(
          accountId: accountId, wishlistId: wishlistId);

      // Loại bỏ sản phẩm khỏi danh sách
      listWishlist.removeWhere((element) => element.wishlistId == wishlistId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Ngừng trạng thái tải nếu lỗi xảy ra
      debugPrint('Lỗi xoá sản phẩm yêu thích: ${e.toString()}');
      notifyListeners();
    }
  }

  // Sắp xếp theo các tiêu chí
  sortList(OrderByEnum data) {
    switch (data) {
      case OrderByEnum.newest:
        listWishlist.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case OrderByEnum.oldest:
        listWishlist.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case OrderByEnum.cheapest:
        listWishlist.sort((a, b) =>
            a.product!.productPrice.compareTo(b.product!.productPrice));
        break;
      case OrderByEnum.mostExpensive:
        listWishlist.sort((a, b) =>
            b.product!.productPrice.compareTo(a.product!.productPrice));
        break;
      default: // Mặc định sắp xếp theo thời gian tạo
        listWishlist.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
  }
}
