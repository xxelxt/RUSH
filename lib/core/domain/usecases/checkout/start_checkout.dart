import 'package:rush/core/domain/entities/account/account.dart';
import 'package:rush/core/domain/entities/cart/cart.dart';
import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:rush/core/domain/repositories/checkout_repository.dart';

class StartCheckout {
  final CheckoutRepository _repository;

  StartCheckout(this._repository);

  Transaction execute({required List<Cart> cart, required Account account}) {
    return _repository.startCheckout(cart: cart, account: account);
  }
}
