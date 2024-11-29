import 'package:rush/config/flavor_config.dart';
import 'package:rush/core/domain/entities/account/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rush/core/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final CollectionReference collectionReference;

  AccountRepositoryImpl({required this.collectionReference});

  @override
  Future<void> banAccount({required String accountId, required bool ban}) async {
    await collectionReference.doc(accountId).update({
      'ban_status': ban,
    });
  }

  @override
  Future<Account?> getAccountProfile({required String accountId}) async {
    var doc = await collectionReference.doc(accountId).get();

    Account? temp;

    if (doc.exists) {
      temp = Account.fromJson(doc.data() as Map<String, dynamic>);
    }

    return temp;
  }

  @override
  Future<List<Account>> getAllAccount() async {
    Query query = collectionReference;
    List<Account> temp = [];

    var data = await query.where('role', isEqualTo: Flavor.user.roleValue).get();

    if (data.docs.isNotEmpty) {
      temp.addAll(data.docs.map((e) => Account.fromJson(e.data() as Map<String, dynamic>)));
    }

    return temp;
  }

  @override
  Future<void> updateAccount({required String accountId, required Map<String, dynamic> data}) async {
    await collectionReference.doc(accountId).update(data);
  }
}
