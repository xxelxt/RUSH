import 'package:rush/core/domain/entities/address/address.dart';
import 'package:rush/core/domain/usecases/address/add_address.dart';
import 'package:rush/core/domain/usecases/address/change_primary_address.dart';
import 'package:rush/core/domain/usecases/address/delete_address.dart';
import 'package:rush/core/domain/usecases/address/get_account_address.dart';
import 'package:rush/core/domain/usecases/address/update_address.dart';
import 'package:flutter/material.dart';

// Sử dụng `ChangeNotifier` để quản lý trạng thái liên quan đến địa chỉ
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

  // Theo dõi trạng thái đang tải
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Danh sách các địa chỉ
  List<Address> _listAddress = [];
  List<Address> get listAddress => _listAddress;

  // Thêm một địa chỉ mới
  Future<void> add({
    required String accountId,
    required Address data, // Thông tin địa chỉ cần thêm
  }) async {
    try {
      _isLoading = true; // Bắt đầu trạng thái tải
      notifyListeners();

      // Gọi usecase để thêm địa chỉ
      await addAddress.execute(accountId: accountId, data: data);
      _listAddress.add(data); // Thêm địa chỉ vào danh sách

      _isLoading = false; // Hoàn thành trạng thái tải
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Ngừng trạng thái tải khi lỗi xảy ra
      notifyListeners();
      debugPrint('Lỗi khi thêm địa chỉ: ${e.toString()}');
    }
  }

  // Lấy danh sách địa chỉ của tài khoản
  getAddress({required String accountId}) async {
    try {
      _isLoading = true;
      notifyListeners();
      _listAddress.clear(); // Xoá danh sách cũ trước khi tải mới

      // Gọi usecase để lấy danh sách địa chỉ
      var response = await getAccountAddress.execute(accountId: accountId);

      if (response.isNotEmpty) {
        _listAddress = response; // Cập nhật danh sách địa chỉ
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Dừng trạng thái tải nếu lỗi xảy ra
      debugPrint('Lỗi khi lấy thông tin địa chỉ: ${e.toString()}');
      notifyListeners();
    }
  }

  // Cập nhật thông tin một địa chỉ
  Future<void> update({
    required String accountId,
    required Address data, // Địa chỉ mới cần cập nhật
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gọi usecase để cập nhật địa chỉ
      await updateAddress.execute(accountId: accountId, data: data);

      // Tìm vị trí của địa chỉ cần cập nhật trong danh sách
      int index = listAddress.indexWhere((element) => element.addressId == data.addressId);
      listAddress[index] = data; // Cập nhật địa chỉ mới

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Dừng trạng thái tải nếu lỗi xảy ra
      debugPrint('Lỗi khi cập nhật địa chỉ: ${e.toString()}');
      notifyListeners();
    }
  }

  // Xoá một địa chỉ
  delete({
    required String accountId,
    required String addressId,
  }) async {
    try {
      // Gọi usecase để xoá địa chỉ
      await deleteAddress.execute(accountId: accountId, addressId: addressId);

      // Xoá địa chỉ khỏi danh sách địa chỉ
      listAddress.removeWhere((element) => element.addressId == addressId);

      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi khi xoá địa chỉ: ${e.toString()}');
      notifyListeners();
    }
  }

  // Thay đổi địa chỉ mặc định
  Future<void> changePrimary({
    required String accountId,
    required Address data, // Địa chỉ mới được chọn làm mặc định
    required Address? oldData, // Địa chỉ cũ (nếu có)
  }) async {
    if (oldData != null && oldData == data) return;

    try {
      // Gọi usecase để thay đổi địa chỉ mặc định
      await changePrimaryAddress.execute(accountId: accountId, data: data);
    } catch (e) {
      debugPrint('Lỗi khi thay đổi địa chỉ mặc định: ${e.toString()}');
    }
  }
}
