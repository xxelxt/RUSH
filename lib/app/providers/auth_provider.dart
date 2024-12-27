// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rush/app/constants/collections_name.dart';
import 'package:rush/config/flavor_config.dart';
import 'package:rush/core/domain/entities/account/account.dart';
import 'package:rush/core/domain/usecases/auth/login_account.dart';
import 'package:rush/core/domain/usecases/auth/logout_account.dart';
import 'package:rush/core/domain/usecases/auth/register_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final LoginAccount loginAccount;
  final RegisterAccount registerAccount;
  final LogoutAccount logoutAccount;

  late Account _account; // Biến lưu trữ thông tin tài khoản
  Account get account => _account;

  AuthProvider({
    required this.loginAccount,
    required this.registerAccount,
    required this.logoutAccount,
  }) {
    isLoggedIn(); // Kiểm tra trạng thái đăng nhập khi khởi tạo
  }

  // Trạng thái tải dữ liệu
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Trạng thái kiểm tra người dùng
  bool _checkUser = true;
  bool get checkUser => _checkUser;

  // Trạng thái đăng nhập của người dùng
  bool _isUserLoggedIn = false;
  bool get isUserLoggedIn => _isUserLoggedIn;

  // Kiểm tra vai trò của người dùng
  bool _isRoleValid = true;
  bool get isRoleValid => _isRoleValid;

  // Kiểm tra trạng thái đăng nhập của người dùng
  isLoggedIn() async {
    _checkUser = true;
    FirebaseAuth authInstance = FirebaseAuth.instance;

    if (authInstance.currentUser != null) {
      var data = await FirebaseFirestore.instance
          .collection(CollectionsName.kACCOUNT)
          .doc(authInstance.currentUser!.uid)
          .get();

      if (data.exists) {
        try {
          _account = Account.fromJson(data.data()!);
        } catch (e) {
          debugPrint('Lỗi khi khởi tạo Account: $e');
        }

        if (_account.role == FlavorConfig.instance.flavor.roleValue &&
            !_account.banStatus) {
          _isUserLoggedIn = true;
          _isRoleValid = true;
        } else {
          authInstance.signOut();
          _isRoleValid = false;
          _isUserLoggedIn = false;
        }
      } else {
        debugPrint('Tài khoản không tồn tại trong Firestore.');
        _isUserLoggedIn = false;
      }
    } else {
      _isUserLoggedIn = false;
    }

    _checkUser = false;
    notifyListeners();
  }

  // Phương thức đăng nhập
  Future<void> login({
    required String emailAddress,
    required String password,
  }) async {
    try {
      _isLoading = true; // Bắt đầu trạng thái tải
      notifyListeners();

      // Gọi usecase để xử lý đăng nhập
      await loginAccount.execute(
        email: emailAddress,
        password: password,
      );

      _isLoading = false; // Hoàn thành trạng thái tải
      await isLoggedIn(); // Kiểm tra trạng thái sau đăng nhập
    } catch (e) {
      _isLoading = false; // Ngừng trạng thái tải khi lỗi xảy ra
      notifyListeners();
      debugPrint('Lỗi khi đăng nhập: ${e.toString()}');
      rethrow;
    }
  }

  // Phương thức đăng ký tài khoản mới
  Future<void> register({
    required String emailAddress, // Email người dùng
    required String password, // Mật khẩu
    required String fullName, // Tên đầy đủ
    required String phoneNumber, // Số điện thoại
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gọi Use Case để xử lý đăng ký
      await registerAccount.execute(
        email: emailAddress,
        password: password.isEmpty ? 'default_password' : password, // Đặt mật khẩu mặc định nếu rỗng
        fullName: fullName,
        phoneNumber: phoneNumber,
        role: FlavorConfig.instance.flavor.roleValue, // Vai trò mặc định từ cấu hình
      );

      _isLoading = false;
      isLoggedIn(); // Kiểm tra trạng thái sau đăng ký
    } catch (e) {
      _isLoading = false; // Ngừng trạng thái tải nếu lỗi xảy ra
      notifyListeners();
      debugPrint('Lỗi khi đăng ký tài khoản mới: ${e.toString()}');
      rethrow;
    }
  }

  // Phương thức đăng xuất
  logout() async {
    try {
      // Gọi usecase để xử lý đăng xuất
      await logoutAccount.execute();

      isLoggedIn(); // Cập nhật trạng thái sau đăng xuất
    } catch (e) {
      debugPrint('Lỗi khi đăng xuất: ${e.toString()}');
      rethrow;
    }
  }

  // Phương thức đặt lại mật khẩu
  resetPassword({required String email}) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gửi email đặt lại mật khẩu
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Ngừng trạng thái tải nếu lỗi xảy ra
      notifyListeners();
      debugPrint('Lỗi khi đặt lại mật khẩu: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> loginWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);

        final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200).height(200)",
        );

        final userDoc = await FirebaseFirestore.instance
            .collection(CollectionsName.kACCOUNT)
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          // Thêm thông tin người dùng vào Firestore với các giá trị mặc định
          await FirebaseFirestore.instance
              .collection(CollectionsName.kACCOUNT)
              .doc(userCredential.user!.uid)
              .set({
            'account_id': userCredential.user!.uid,
            'full_name': userData['name'] ?? 'Người dùng Facebook',
            'email_address': userData['email'] ?? 'unknown_email@facebook.com',
            'phone_number': '0', // Facebook không cung cấp số điện thoại
            'role': FlavorConfig.instance.flavor.roleValue,
            'ban_status': false,
            'primary_payment_method': null, // Không có phương thức thanh toán ban đầu
            'primary_address': null, // Không có địa chỉ ban đầu
            'photo_profile_url': '', // URL ảnh đại diện từ Facebook
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          });
          debugPrint('Người dùng mới được đăng ký thành công.');
        } else {
          debugPrint('Người dùng đã tồn tại.');
        }

        // Kiểm tra trạng thái sau khi đăng nhập
        await isLoggedIn();
      } else {
        throw Exception('Đăng nhập Facebook thất bại.');
      }
    } catch (e) {
      debugPrint('Lỗi khi đăng nhập Facebook: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập Facebook thất bại: $e')),
      );
    }
  }
}
