import 'package:rush/core/domain/entities/product/product.dart';
import 'package:rush/core/domain/repositories/product_repository.dart';

class UpdateProduct {
  final ProductRepository _repository;

  UpdateProduct(this._repository);

  Future<void> execute({required Product data}) async {
    return _repository.updateProduct(product: data);
  }
}
