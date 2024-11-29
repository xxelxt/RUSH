import 'dart:typed_data';

import 'package:rush/app/constants/order_by_value.dart';
import 'package:rush/core/domain/entities/account/account.dart';
import 'package:rush/core/domain/usecases/account/ban_account.dart';
import 'package:rush/core/domain/usecases/account/get_account_profile.dart';
import 'package:rush/core/domain/usecases/account/get_all_account.dart';
import 'package:rush/core/domain/usecases/account/update_account.dart';
import 'package:rush/utils/compress_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountProvider with ChangeNotifier {
  final GetAccountProfile getAccountProfile;
  final GetAllAccount getAllAccount;
  final UpdateAccount updateAccount;
  final BanAccount banAccount;

  AccountProvider({
    required this.getAccountProfile,
    required this.getAllAccount,
    required this.updateAccount,
    required this.banAccount,
  });

  // Load State
  bool _isLoadProfile = true;
  bool get isLoadProfile => _isLoadProfile;
  bool _isLoadListAccount = true;
  bool get isLoadListAccount => _isLoadListAccount;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Account
  late Account _account;
  Account get account => _account;

  // List Account
  List<Account> _listAccount = [];
  List<Account> get listAccount => _listAccount;

  getProfile() async {
    try {
      _isLoadProfile = true;
      notifyListeners();

      String accountId = FirebaseAuth.instance.currentUser!.uid;
      var response = await getAccountProfile.execute(accountId: accountId);

      if (response != null) {
        _account = response;
      }

      _isLoadProfile = false;
      notifyListeners();
    } catch (e) {
      _isLoadProfile = false;
      debugPrint('Get Profile Error: ${e.toString()}');
      notifyListeners();
    }
  }

  getListAccount({
    String search = '',
    OrderByEnum orderByEnum = OrderByEnum.newest,
  }) async {
    try {
      _isLoadListAccount = true;
      notifyListeners();
      _listAccount.clear();

      var response = await getAllAccount.execute();

      if (response.isNotEmpty) {
        _listAccount = response;
        sortList(orderByEnum);
        if (search.isNotEmpty) {
          _listAccount =
              _listAccount.where((element) => element.fullName.toLowerCase().contains(search.toLowerCase())).toList();
        }
      }

      _isLoadListAccount = false;
      notifyListeners();
    } catch (e) {
      _isLoadListAccount = false;
      debugPrint('Load List Account Error: ${e.toString()}');
      notifyListeners();
    }
  }

  update({required Map<String, dynamic> data}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await updateAccount.execute(accountId: account.accountId, data: data);

      _isLoading = false;
      notifyListeners();

      getProfile();
    } catch (e) {
      _isLoading = false;
      debugPrint('Update Account Error: ${e.toString()}');
      notifyListeners();
    }
  }

  ban({required String accountId, required bool ban}) async {
    try {
      await banAccount.execute(accountId: accountId, ban: ban);
      getListAccount();
    } catch (e) {
      _isLoading = false;
      debugPrint('Ban Account Error: ${e.toString()}');
      notifyListeners();
    }
  }

  updatePhotoProfile(XFile image) async {
    try {
      _isLoading = true;
      notifyListeners();

      Uint8List data = await image.readAsBytes();

      data = await CompressImage.startCompress(data);

      Reference ref = FirebaseStorage.instance.ref().child('Photo Profile/${account.fullName}/${image.name}');

      // Save the image to firebase storage
      final dataImage = await ref.putData(data);

      // Get the img url from Firebase Storage
      String imageUrl = await dataImage.ref.getDownloadURL();

      await updateAccount.execute(accountId: account.accountId, data: {
        'photo_profile_url': imageUrl,
      });

      _isLoading = false;
      notifyListeners();

      getProfile();
    } catch (e) {
      _isLoading = false;
      debugPrint('Update Photo Profile Error: ${e.toString()}');
      notifyListeners();
    }
  }

  sortList(OrderByEnum data) {
    switch (data) {
      case OrderByEnum.newest:
        listAccount.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case OrderByEnum.oldest:
        listAccount.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      default:
        listAccount.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
  }
}
