import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rush/app/constants/collections_name.dart';
import 'package:rush/core/domain/entities/cart/cart.dart';
import 'package:rush/core/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CollectionReference collectionReference;

  CartRepositoryImpl({required this.collectionReference});

  @override
  Future<void> addAccountCart({required String accountId, required Cart data}) async {
    await collectionReference.doc(accountId).collection(CollectionsName.kCART).doc(data.cartId).set(data.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> deleteAccountCart({required String accountId, required String cartId}) async {
    await collectionReference.doc(accountId).collection(CollectionsName.kCART).doc(cartId).delete();
  }

  @override
  Future<List<Cart>> getAccountCart({required String accountId}) async {
    var data = await collectionReference.doc(accountId).collection(CollectionsName.kCART).get();

    List<Cart> temp = [];

    if (data.docs.isNotEmpty) {
      temp.addAll(data.docs.map((e) => Cart.fromJson(e.data())));
    }

    return temp;
  }

  @override
  Future<void> updateAccountCart({required String accountId, required Cart data}) async {
    await collectionReference.doc(accountId).collection(CollectionsName.kCART).doc(data.cartId).update(data.toJson());
  }
}
