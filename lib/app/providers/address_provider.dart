import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/core/domain/usecases/address/add_address.dart';
import 'package:rush/core/domain/usecases/address/change_primary_address.dart';
import 'package:rush/core/domain/usecases/address/delete_address.dart';
import 'package:rush/core/domain/usecases/address/get_account_address.dart';
import 'package:rush/core/domain/usecases/address/update_address.dart';
import 'package:flutter/material.dart';

class AddressProvider with ChangeNotifier {
  final AddAddress addAddress;
  final GetAccountAddress getAccountAddress;
  final UpdateAddress updateAddress;
  final DeleteAddress deleteAddress;
  final ChangePrimaryAddress changePrimaryAddress;

  AddressProvider({
    required this.addAddress,
    required this.getAccountAddress,
    required this.updateAddress,
    required this.deleteAddress,
    required this.changePrimaryAddress,
  });

  // Loading State
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // List Address
  List<Address> _listAddress = [];
  List<Address> get listAddress => _listAddress;

  Future<void> add({
    required String accountId,
    required Address data,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await addAddress.execute(accountId: accountId, data: data);
      _listAddress.add(data);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Add Address Error: ${e.toString()}');
    }
  }

  getAddress({required String accountId}) async {
    try {
      _isLoading = true;
      notifyListeners();
      _listAddress.clear();

      var response = await getAccountAddress.execute(accountId: accountId);

      if (response.isNotEmpty) {
        _listAddress = response;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Get Address Error: ${e.toString()}');
      notifyListeners();
    }
  }

  Future<void> update({
    required String accountId,
    required Address data,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await updateAddress.execute(accountId: accountId, data: data);
      int index = listAddress.indexWhere((element) => element.addressId == data.addressId);
      listAddress[index] = data;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Update Address Error: ${e.toString()}');
      notifyListeners();
    }
  }

  delete({
    required String accountId,
    required String addressId,
  }) async {
    try {
      await deleteAddress.execute(accountId: accountId, addressId: addressId);
      listAddress.removeWhere((element) => element.addressId == addressId);

      notifyListeners();
    } catch (e) {
      debugPrint('Delete Address Error: ${e.toString()}');
      notifyListeners();
    }
  }

  Future<void> changePrimary({
    required String accountId,
    required Address data,
    required Address? oldData,
  }) async {
    if (oldData != null && oldData == data) return;

    try {
      await changePrimaryAddress.execute(accountId: accountId, data: data);
    } catch (e) {
      debugPrint('Change Primary Address Error: ${e.toString()}');
    }
  }
}
