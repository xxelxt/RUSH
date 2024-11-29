import 'package:rush/core/domain/repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository _repository;

  DeleteProduct(this._repository);

  Future<void> execute({required String productId}) async {
    return await _repository.deleteProduct(productId: productId);
  }
}
