import 'package:rush/core/domain/entities/product/product.dart';
import 'package:rush/core/domain/repositories/product_repository.dart';

class AddProduct {
  final ProductRepository _repository;

  AddProduct(this._repository);

  Future<void> execute({required Product data}) async {
    return _repository.addProduct(product: data);
  }
}
