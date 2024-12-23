import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

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

// Sử dụng `ChangeNotifier` để quản lý trạng thái và thông báo cập nhật UI
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

  // Các biến trạng thái
  bool _isLoadProfile = true; // Trạng thái đang tải thông tin tài khoản
  bool get isLoadProfile => _isLoadProfile;

  bool _isLoadListAccount = true; // Trạng thái đang tải danh sách tài khoản
  bool get isLoadListAccount => _isLoadListAccount;

  bool _isLoading = false; // Trạng thái chung đang xử lý
  bool get isLoading => _isLoading;

  // Biến lưu thông tin tài khoản
  late Account _account;
  Account get account => _account;

  // Biến lưu danh sách tài khoản
  List<Account> _listAccount = [];
  List<Account> get listAccount => _listAccount;

  Future<String> uploadImageToCloudinary(Uint8List imageBytes, String fileName) async {
    const String cloudName = 'rush-elt';
    const String uploadPreset = 'profile_avatar';

    final Uri uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..fields['folder'] = 'Profile Photos'
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: fileName,
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await http.Response.fromStream(response);
      final responseData = json.decode(responseBody.body);
      return responseData['secure_url'];
    } else {
      throw Exception('Tải ảnh lên Cloudinary thất bại với mã lỗi ${response.statusCode}');
    }
  }

  // Lấy thông tin tài khoản hiện tại
  getProfile() async {
    try {
      _isLoadProfile = true; // Đặt trạng thái đang tải
      notifyListeners(); // Cập nhật UI

      // Lấy ID tài khoản hiện tại
      String accountId = FirebaseAuth.instance.currentUser!.uid;

      // Gọi usecase để lấy thông tin tài khoản
      var response = await getAccountProfile.execute(accountId: accountId);

      if (response != null) {
        _account = response; // Cập nhật thông tin tài khoản
      }

      _isLoadProfile = false; // Hoàn thành tải
      notifyListeners();
    } catch (e) {
      _isLoadProfile = false;
      debugPrint('Lỗi khi lấy thông tin tài khoản: ${e.toString()}');
      notifyListeners();
    }
  }

  // Lấy danh sách tài khoản với các tuỳ chọn tìm kiếm và sắp xếp
  getListAccount({
    String search = '',
    OrderByEnum orderByEnum = OrderByEnum.newest,
  }) async {
    try {
      _isLoadListAccount = true;
      notifyListeners();
      _listAccount.clear();

      // Gọi usecase để lấy danh sách tài khoản
      var response = await getAllAccount.execute();

      if (response.isNotEmpty) {
        _listAccount = response; // Lưu danh sách tài khoản
        sortList(orderByEnum); // Sắp xếp danh sách

        // Lọc danh sách theo từ khoá tìm kiếm nếu có
        if (search.isNotEmpty) {
          _listAccount = _listAccount
              .where((element) =>
              element.fullName.toLowerCase().contains(search.toLowerCase()))
              .toList();
        }
      }

      _isLoadListAccount = false;
      notifyListeners();
    } catch (e) {
      _isLoadListAccount = false;
      debugPrint('Lỗi khi tải danh sách tài khoản: ${e.toString()}');
      notifyListeners();
    }
  }

  // Cập nhật thông tin tài khoản
  update({required Map<String, dynamic> data}) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gọi usecase để cập nhật thông tin tài khoản
      await updateAccount.execute(accountId: account.accountId, data: data);

      _isLoading = false;
      notifyListeners();

      getProfile(); // Lấy lại thông tin tài khoản sau khi cập nhật
    } catch (e) {
      _isLoading = false;
      debugPrint('Lỗi khi cập nhật thông tin tài khoản: ${e.toString()}');
      notifyListeners();
    }
  }

  // Khoá hoặc mở khoá tài khoản
  ban({required String accountId, required bool ban}) async {
    try {
      await banAccount.execute(accountId: accountId, ban: ban); // Gọi usecase
      getListAccount(); // Cập nhật lại danh sách tài khoản
    } catch (e) {
      _isLoading = false;
      debugPrint('Lỗi khi khoá tài khoản: ${e.toString()}');
      notifyListeners();
    }
  }

  // Cập nhật ảnh đại diện
  updatePhotoProfile(XFile image) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Đọc dữ liệu ảnh từ file
      Uint8List data = await image.readAsBytes();

      // Nén ảnh để tối ưu kích thước
      data = await CompressImage.startCompress(data);

      // Tải ảnh lên Cloudinary
      String imageUrl = await uploadImageToCloudinary(data, image.name);

      // Cập nhật URL ảnh đại diện trong tài khoản
      await updateAccount.execute(accountId: account.accountId, data: {
        'photo_profile_url': imageUrl,
      });

      _isLoading = false;
      notifyListeners();

      getProfile(); // Cập nhật lại thông tin tài khoản sau khi thay đổi ảnh
    } catch (e) {
      _isLoading = false;
      debugPrint('Lỗi cập nhật ảnh đại diện: ${e.toString()}');
      notifyListeners();
    }
  }

  // Sắp xếp danh sách tài khoản
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
