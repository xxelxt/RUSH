import 'package:rush/core/domain/entities/cart/cart.dart';

abstract class CartRepository {
  Future<List<Cart>> getAccountCart({required String accountId});

  Future<void> addAccountCart({required String accountId, required Cart data});

  Future<void> updateAccountCart({required String accountId, required Cart data});

  Future<void> deleteAccountCart({required String accountId, required String cartId});
}
