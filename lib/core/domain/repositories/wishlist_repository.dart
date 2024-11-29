import 'package:rush/core/domain/entities/wishlist/wishlist.dart';

abstract class WishlistRepository {
  Future<List<Wishlist>> getAccountWishlist({
    required String accountId,
    String search = '',
    String orderBy = 'created_at',
    bool descending = true,
  });

  Future<void> addAccountWishlist({required String accountId, required Wishlist wishlist});

  Future<void> deleteAccountWishlist({required String accountId, required String wishlistId});
}
