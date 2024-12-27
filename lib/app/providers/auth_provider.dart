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

class AuthProvider with ChangeNotifier {
  final LoginAccount loginAccount;
  final RegisterAccount registerAccount;
  final LogoutAccount logoutAccount;

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
    _checkUser = true; // Bắt đầu kiểm tra trạng thái
    FirebaseAuth authInstance = FirebaseAuth.instance;

    // Kiểm tra nếu có người dùng hiện tại
    if (authInstance.currentUser != null) {
      // Lấy thông tin tài khoản từ Firestore
      var data = await FirebaseFirestore.instance
          .collection(CollectionsName.kACCOUNT)
          .doc(authInstance.currentUser!.uid)
          .get();

      Account account = Account.fromJson(data.data()!);

      // Kiểm tra vai trò người dùng và trạng thái bị khoá
      if (account.role == FlavorConfig.instance.flavor.roleValue && !account.banStatus) {
        _isUserLoggedIn = true; // Người dùng hợp lệ
        _isRoleValid = true;
      } else {
        authInstance.signOut(); // Đăng xuất nếu không hợp lệ
        _isRoleValid = false;
        _isUserLoggedIn = false;
      }
    } else {
      _isUserLoggedIn = false; // Không có người dùng đăng nhập
    }

    _checkUser = false; // Hoàn thành kiểm tra
    notifyListeners(); // Cập nhật trạng thái UI
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
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        role: FlavorConfig.instance.flavor.roleValue, // Vai trò mặc định từ cấu hình
      );

      _isLoading = false;
      await isLoggedIn(); // Kiểm tra trạng thái sau đăng ký
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

      await isLoggedIn(); // Cập nhật trạng thái sau đăng xuất
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

  // Đăng nhập bằng Facebook
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Lấy access token từ Facebook
        final AccessToken accessToken = result.accessToken!;

        // Sử dụng token để tạo credential
        final OAuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);

        // Đăng nhập Firebase bằng credential từ Facebook
        await _auth.signInWithCredential(credential);

        // Kiểm tra trạng thái đăng nhập sau khi đăng nhập thành công
        await isLoggedIn();
        notifyListeners();
      } else {
        throw Exception('Facebook login failed');
      }
    } catch (e) {
      throw Exception('Error logging in with Facebook: $e');
    }
  }
}