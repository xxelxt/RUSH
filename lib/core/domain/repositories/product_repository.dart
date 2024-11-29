import 'package:rush/core/domain/entities/product/product.dart';
import 'package:rush/core/domain/entities/review/review.dart';

abstract class ProductRepository {
  Future<List<Product>> getListProduct({
    String search = '',
    String orderBy = 'created_at',
    bool descending = true,
  });

  Future<Product?> getProduct({required String productId});

  Future<List<Review>> getProductReview({
    required String productId,
    String orderBy = 'created_at',
    bool descending = true,
  });

  Future<void> addProduct({required Product product});

  Future<void> updateProduct({required Product product});

  Future<void> deleteProduct({required String productId});
}
