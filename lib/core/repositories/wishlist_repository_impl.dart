import 'package:rush/app/constants/collections_name.dart';
import 'package:rush/core/domain/entities/wishlist/wishlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rush/core/domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final CollectionReference collectionReference;
  WishlistRepositoryImpl({required this.collectionReference});

  @override
  Future<void> addAccountWishlist({required String accountId, required Wishlist wishlist}) async {
    await collectionReference
        .doc(accountId)
        .collection(CollectionsName.kWISHLIST)
        .doc(wishlist.wishlistId)
        .set(wishlist.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> deleteAccountWishlist({required String accountId, required String wishlistId}) async {
    await collectionReference.doc(accountId).collection(CollectionsName.kWISHLIST).doc(wishlistId).delete();
  }

  @override
  Future<List<Wishlist>> getAccountWishlist({
    required String accountId,
    String search = '',
    String orderBy = 'created_at',
    bool descending = true,
  }) async {
    Query query = collectionReference
        .doc(accountId)
        .collection(CollectionsName.kWISHLIST)
        .orderBy(orderBy, descending: descending);
    List<Wishlist> temp = [];

    var data = await query.get();

    if (data.docs.isNotEmpty) {
      temp.addAll(data.docs.map((e) => Wishlist.fromJson(e.data() as Map<String, dynamic>)));
    }

    return temp;
  }
}
