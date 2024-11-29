import 'package:rush/core/domain/repositories/wishlist_repository.dart';

class DeleteAccountWishlist {
  final WishlistRepository _repository;

  DeleteAccountWishlist(this._repository);

  Future<void> execute({
    required String accountId,
    required String wishlistId,
  }) async {
    return _repository.deleteAccountWishlist(
      accountId: accountId,
      wishlistId: wishlistId,
    );
  }
}
