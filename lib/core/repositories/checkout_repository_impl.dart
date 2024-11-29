import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:rush/core/domain/entities/transaction/transaction.dart';
import 'package:rush/core/domain/entities/cart/cart.dart';
import 'package:rush/core/domain/entities/account/account.dart';
import 'package:rush/core/domain/repositories/checkout_repository.dart';
import 'package:rush/utils/extension.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final firestore.CollectionReference collectionReference;
  CheckoutRepositoryImpl({required this.collectionReference});

  @override
  Future<void> pay({required Transaction data}) async {
    await collectionReference.doc(data.transactionId).set(data.toJson(), firestore.SetOptions(merge: true));
  }

  @override
  Transaction startCheckout({required List<Cart> cart, required Account account}) {
    double subTotal = 0;
    for (var element in cart) {
      subTotal += element.product!.productPrice * element.quantity;
    }

    // TODO: Change your service fee here
    double serviceFee = 0.5;

    // TODO: Change your shipping fee
    // I'm using flat rate shipping fee here, for conveninece
    double shippingFee = 4;

    Transaction temp = Transaction(
      transactionId: ''.generateUID(),
      accountId: account.accountId,
      purchasedProduct: cart,
      subTotal: subTotal,
      transactionStatus: TransactionStatus.processed.value,
      totalPrice: subTotal,
      serviceFee: serviceFee,
      shippingFee: shippingFee,
    );

    return temp;
  }
}
