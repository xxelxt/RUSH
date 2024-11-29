import 'package:rush/core/domain/entities/product/product.dart';
import 'package:rush/core/domain/repositories/product_repository.dart';

class GetListProduct {
  final ProductRepository _repository;

  GetListProduct(this._repository);

  Future<List<Product>> execute({
    String search = '',
    String orderBy = 'created_at',
    bool descending = true,
  }) async {
    return _repository.getListProduct(
      search: search,
      orderBy: orderBy,
      descending: descending,
    );
  }
}
