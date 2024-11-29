import 'package:rush/core/domain/entities/wishlist/wishlist.dart';
import 'package:rush/core/domain/repositories/wishlist_repository.dart';

class GetAccountWishlist {
  final WishlistRepository _repository;

  GetAccountWishlist(this._repository);

  Future<List<Wishlist>> execute({
    required String accountId,
    String search = '',
    String orderBy = 'created_at',
    bool descending = true,
  }) async {
    return _repository.getAccountWishlist(
      accountId: accountId,
      search: search,
      orderBy: orderBy,
      descending: descending,
    );
  }
}
