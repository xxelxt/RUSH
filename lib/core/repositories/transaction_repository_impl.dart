import 'package:rush/app/constants/collections_name.dart';
import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:rush/core/domain/entities/review/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:rush/core/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final firestore.CollectionReference collectionReference;

  TransactionRepositoryImpl({required this.collectionReference});

  @override
  Future<void> acceptTransaction({required Transaction data}) async {
    await collectionReference.doc(data.transactionId).update({
      'transaction_status': TransactionStatus.done.value,
    });
  }

  @override
  Future<void> addReview({required String transactionId, required Review data}) async {
    await firestore.FirebaseFirestore.instance
        .collection(CollectionsName.kPRODUCT)
        .doc(data.productId)
        .collection(CollectionsName.kREVIEW)
        .doc(data.reviewId)
        .set(data.toJson(), firestore.SetOptions(merge: true));

    // Calculate Rating
    var dataReview = await firestore.FirebaseFirestore.instance
        .collection(CollectionsName.kPRODUCT)
        .doc(data.productId)
        .collection(CollectionsName.kREVIEW)
        .get();
    List<Review> tempReview = [];

    if (dataReview.docs.isNotEmpty) {
      tempReview.addAll(
        dataReview.docs.map(
          (e) => Review.fromJson(e.data()),
        ),
      );
    }

    double totalStar = 0;
    double rating = 0;
    int totalReviews = 0;

    totalReviews = tempReview.length;

    for (var element in tempReview) {
      totalStar += element.star;
    }

    rating = totalStar / totalReviews;

    await firestore.FirebaseFirestore.instance.collection(CollectionsName.kPRODUCT).doc(data.productId).update({
      'total_reviews': totalReviews,
      'rating': rating,
    });
  }

  @override
  Future<void> changeTransactionStatus({required String transactionID, required int status}) async {
    await collectionReference.doc(transactionID).update({
      'transaction_status': status,
    });
  }

  @override
  Future<List<Transaction>> getAccountTransaction({
    required String accountId,
  }) async {
    firestore.Query query = collectionReference;
    List<Transaction> temp = [];

    var data = await query.where('account_id', isEqualTo: accountId).get();

    if (data.docs.isNotEmpty) {
      temp.addAll(data.docs.map((e) => Transaction.fromJson(e.data() as Map<String, dynamic>)));
    }

    return temp;
  }

  @override
  Future<List<Transaction>> getAllTransaction() async {
    firestore.Query query = collectionReference;
    List<Transaction> temp = [];

    var data = await query.get();

    if (data.docs.isNotEmpty) {
      temp.addAll(data.docs.map((e) => Transaction.fromJson(e.data() as Map<String, dynamic>)));
    }

    return temp;
  }

  @override
  Future<Transaction?> getTransaction({required String transactionId}) async {
    var data = await collectionReference.doc(transactionId).get();

    if (data.exists) {
      return Transaction.fromJson(data.data() as Map<String, dynamic>);
    }

    return null;
  }
}
