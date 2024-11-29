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
  // Use Case
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

  // Load state
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // List Product
  List<Product> _listProduct = [];
  List<Product> get listProduct => _listProduct;

  // List Product Review
  List<Review> _listProductReview = [];
  List<Review> get listProductReview => _listProductReview;

  // Detail Product
  Product? _detailProduct;
  Product? get detailProduct => _detailProduct;

  Future<void> loadListProduct({
    String search = '',
    OrderByEnum orderByEnum = OrderByEnum.newest,
  }) async {
    _isLoading = true;
    notifyListeners();
    _listProduct.clear();

    try {
      var response = await getListProduct.execute(
        search: search,
      );

      if (response.isNotEmpty || search.isNotEmpty) {
        _listProduct = response;
        sortList(orderByEnum);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Load Product Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> loadDetailProduct({required String productId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      var responseDetail = await getProduct.execute(productId: productId);
      var responseReview = await getProductReview.execute(productId: productId);

      if (responseDetail != null) {
        _detailProduct = responseDetail;
      }

      if (responseReview.isNotEmpty) {
        _listProductReview = responseReview;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Load Detail Product Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> add({required Product data}) async {
    try {
      await addProduct.execute(data: data);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Add Product Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> update({required Product data}) async {
    try {
      await updateProduct.execute(data: data);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Update Product Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> delete({required String productId}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await deleteProduct.execute(productId: productId);

      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Delete Product Error: ${e.toString()}');
      rethrow;
    }
  }

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
