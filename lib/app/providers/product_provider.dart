import 'package:rush/core/domain/entities/product/product.dart';
import 'package:rush/core/domain/entities/review/review.dart';
import 'package:rush/core/domain/usecases/product/add_product.dart';
import 'package:rush/core/domain/usecases/product/delete_product.dart';
import 'package:rush/core/domain/usecases/product/get_list_product.dart';
import 'package:rush/core/domain/usecases/product/get_product.dart';
import 'package:rush/core/domain/usecases/product/get_product_review.dart';
import 'package:rush/core/domain/usecases/product/update_product.dart';
import 'package:flutter/material.dart';

import '../constants/order_by_value.dart';

class ProductProvider with ChangeNotifier {
  final GetListProduct getListProduct;
  final GetProduct getProduct;
  final GetProductReview getProductReview;
  final AddProduct addProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;

  ProductProvider({
    required this.getListProduct,
    required this.getProduct,
    required this.getProductReview,
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
  });

  // Trạng thái tải dữ liệu
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  set setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Thông báo cập nhật UI
  }

  // Danh sách sản phẩm
  List<Product> _listProduct = [];
  List<Product> get listProduct => _listProduct;

  // Danh sách đánh giá sản phẩm
  List<Review> _listProductReview = [];
  List<Review> get listProductReview => _listProductReview;

  // Chi tiết sản phẩm
  Product? _detailProduct;
  Product? get detailProduct => _detailProduct;

  // Tải danh sách sản phẩm
  Future<void> loadListProduct({
    String search = '',
    OrderByEnum orderByEnum = OrderByEnum.newest,
  }) async {
    _isLoading = true;
    notifyListeners();
    _listProduct.clear(); // Xoá danh sách cũ trước khi tải mới

    try {
      // Gọi usecase để lấy danh sách sản phẩm
      var response = await getListProduct.execute(search: search);

      if (response.isNotEmpty || search.isNotEmpty) {
        _listProduct = response; // Cập nhật danh sách sản phẩm
        sortList(orderByEnum); // Sắp xếp danh sách
      }

      _isLoading = false; // Dừng trạng thái tải
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Lỗi khi tải sản phẩm: ${e.toString()}');
      rethrow;
    }
  }

  // Tải chi tiết sản phẩm
  Future<void> loadDetailProduct({required String productId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Gọi usecase để lấy chi tiết sản phẩm
      var responseDetail = await getProduct.execute(productId: productId);

      // Gọi usecase để lấy đánh giá sản phẩm
      var responseReview = await getProductReview.execute(productId: productId);

      if (responseDetail != null) {
        _detailProduct = responseDetail; // Cập nhật thông tin chi tiết sản phẩm
      }

      if (responseReview.isNotEmpty) {
        _listProductReview = responseReview; // Cập nhật danh sách đánh giá
      }

      _isLoading = false; // Dừng trạng thái tải
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Lỗi khi tải chi tiết sản phẩm: ${e.toString()}');
      rethrow;
    }
  }

  // Thêm sản phẩm mới
  Future<void> add({required Product data}) async {
    try {
      // Gọi usecase để thêm sản phẩm
      await addProduct.execute(data: data);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Lỗi khi thêm sản phẩm: ${e.toString()}');
      rethrow;
    }
  }

  // Cập nhật sản phẩm
  Future<void> update({required Product data}) async {
    try {
      // Gọi usecase để cập nhật sản phẩm
      await updateProduct.execute(data: data);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Lỗi khi cập nhật sản phẩm: ${e.toString()}');
      rethrow;
    }
  }

  // Xoá sản phẩm
  Future<void> delete({required String productId}) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gọi usecase để xoá sản phẩm
      await deleteProduct.execute(productId: productId);

      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Lỗi khi xoá sản phẩm: ${e.toString()}');
      rethrow;
    }
  }

  // Sắp xếp danh sách sản phẩm theo các tiêu chí
  sortList(OrderByEnum data) {
    switch (data) {
      case OrderByEnum.newest:
        listProduct.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case OrderByEnum.oldest:
        listProduct.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case OrderByEnum.cheapest:
        listProduct.sort((a, b) => a.productPrice.compareTo(b.productPrice));
        break;
      case OrderByEnum.mostExpensive:
        listProduct.sort((a, b) => b.productPrice.compareTo(a.productPrice));
        break;
      default:
        listProduct.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
  }
}
