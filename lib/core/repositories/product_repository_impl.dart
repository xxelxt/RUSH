import 'package:rush/app/constants/collections_name.dart';
import 'package:rush/core/domain/entities/review/review.dart';
import 'package:rush/core/domain/entities/product/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rush/core/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final CollectionReference collectionReference;
  ProductRepositoryImpl({required this.collectionReference});

  @override
  Future<void> addProduct({required Product product}) async {
    await collectionReference.doc(product.productId).set(product.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> deleteProduct({required String productId}) async {
    await collectionReference.doc(productId).update({
      'is_deleted': true,
      'stock': 0,
    });
  }

  @override
  Future<List<Product>> getListProduct({
    String search = '',
    String orderBy = 'created_at',
    bool descending = true,
  }) async {
    Query query = collectionReference.where('is_deleted', isEqualTo: false);
    List<Product> temp = [];

    var data = await query.get();

    if (data.docs.isNotEmpty) {
      temp.addAll(data.docs.map((e) => Product.fromJson(e.data() as Map<String, dynamic>)));
    }

    if (search.isNotEmpty) {
      temp = temp.where((element) => element.productName.toLowerCase().contains(search.toLowerCase())).toList();
    }

    return temp;
  }

  @override
  Future<Product?> getProduct({required String productId}) async {
    var data = await collectionReference.doc(productId).get();

    if (data.exists) {
      return Product.fromJson(data.data() as Map<String, dynamic>);
    }

    return null;
  }

  @override
  Future<List<Review>> getProductReview({
    required String productId,
    String orderBy = 'created_at',
    bool descending = true,
  }) async {
    Query query =
        collectionReference.doc(productId).collection(CollectionsName.kREVIEW).orderBy(orderBy, descending: descending);
    List<Review> temp = [];

    var data = await query.get();

    if (data.docs.isNotEmpty) {
      temp.addAll(data.docs.map((e) => Review.fromJson(e.data() as Map<String, dynamic>)));
    }

    return temp;
  }

  @override
  Future<void> updateProduct({required Product product}) async {
    await collectionReference.doc(product.productId).update(product.toJson());
  }
}
