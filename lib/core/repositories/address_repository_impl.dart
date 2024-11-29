import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rush/app/constants/collections_name.dart';
import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/core/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final CollectionReference collectionReference;

  AddressRepositoryImpl({required this.collectionReference});

  @override
  Future<void> addAddress({required String accountId, required Address data}) async {
    await collectionReference.doc(accountId).collection(CollectionsName.kADDRESS).doc(data.addressId).set(data.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> deleteAddress({required String accountId, required String addressId}) async {
    await collectionReference.doc(accountId).collection(CollectionsName.kADDRESS).doc(addressId).delete();
  }

  @override
  Future<List<Address>> getAccountAddress({required String accountId}) async {
    var data = await collectionReference.doc(accountId).collection(CollectionsName.kADDRESS).get();

    List<Address> temp = [];

    if (data.docs.isNotEmpty) {
      temp.addAll(data.docs.map((e) => Address.fromJson(e.data())));
    }

    return temp;
  }

  @override
  Future<void> updateAddress({required String accountId, required Address data}) async {
    await collectionReference.doc(accountId).collection(CollectionsName.kADDRESS).doc(data.addressId).update(data.toJson());
  }

  @override
  Future<void> changePrimaryAddress({required String accountId, required Address address}) async {
    await collectionReference.doc(accountId).update({
      'primary_address': address.toJson(),
    });
  }
}
