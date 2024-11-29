import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rush/app/constants/collections_name.dart';
import 'package:rush/core/domain/entities/payment_method/payment_method.dart';
import 'package:rush/core/domain/repositories/payment_method_repository.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final CollectionReference collectionReference;
  PaymentMethodRepositoryImpl({required this.collectionReference});

  @override
  Future<void> addPaymentMethod({required String accountId, required PaymentMethod data}) async {
    await collectionReference.doc(accountId).collection(CollectionsName.kPAYMENTMETHOD).doc(data.paymentMethodId).set(data.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> deletePaymentMethod({required String accountId, required String paymentMethodId}) async {
    await collectionReference.doc(accountId).collection(CollectionsName.kPAYMENTMETHOD).doc(paymentMethodId).delete();
  }

  @override
  Future<List<PaymentMethod>> getAccountPaymentMethod({required String accountId}) async {
    var data = await collectionReference.doc(accountId).collection(CollectionsName.kPAYMENTMETHOD).get();

    List<PaymentMethod> temp = [];

    if (data.docs.isNotEmpty) {
      temp.addAll(data.docs.map((e) => PaymentMethod.fromJson(e.data())));
    }

    return temp;
  }

  @override
  Future<void> updatePaymentMethod({required String accountId, required PaymentMethod data}) async {
    await collectionReference.doc(accountId).collection(CollectionsName.kPAYMENTMETHOD).doc(data.paymentMethodId).update(data.toJson());
  }

  @override
  Future<void> changePrimaryPaymentMethod({required String accountId, required PaymentMethod paymentMethod}) async {
    await collectionReference.doc(accountId).update({
      'primary_payment_method': paymentMethod.toJson(),
    });
  }
}
