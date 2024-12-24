// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // Sử dụng `ChangeNotifier` để quản lý trạng thái chế độ tối
// class DarkModeProvider with ChangeNotifier {
//   // Trạng thái hiện tại của chế độ tối
//   bool _isDarkMode = false;
//   bool get isDarkMode => _isDarkMode;
//
//   // Trạng thái tải dữ liệu
//   bool _isLoading = true;
//   bool get isLoading => _isLoading;
//
//   getDarkMode() async {
//     try {
//       _isLoading = true; // Đặt trạng thái đang tải
//
//       // Truy cập SharedPreferences để lấy dữ liệu
//       final prefs = await SharedPreferences.getInstance();
//
//       // Kiểm tra nếu có giá trị `is_dark_mode` được lưu trữ
//       if (prefs.containsKey('is_dark_mode')) {
//         // Lấy giá trị chế độ tối (nếu có)
//         _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
//       } else {
//         // Nếu không có, thiết lập giá trị mặc định là `false` (chế độ sáng)
//         _isDarkMode = false;
//         await prefs.setBool('is_dark_mode', _isDarkMode); // Lưu giá trị vào SharedPreferences
//       }
//
//       _isLoading = false; // Dừng trạng thái tải
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Lỗi truy vấn chế độ tối: ${e.toString()}');
//     }
//   }
//
//   // Thiết lập giá trị chế độ tối
//   setDarkMode(bool value) async {
//     try {
//       // Truy cập SharedPreferences để lưu giá trị
//       final prefs = await SharedPreferences.getInstance();
//
//       _isDarkMode = value; // Cập nhật trạng thái chế độ tối
//       prefs.setBool('is_dark_mode', value); // Lưu giá trị vào SharedPreferences
//
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Lỗi khi chuyển sang chế độ tối: ${e.toString()}');
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeProvider with ChangeNotifier {
  final SharedPreferences _prefs;

  DarkModeProvider(this._prefs);

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> getDarkMode() async {
    try {
      _isLoading = true;

      if (_prefs.containsKey('is_dark_mode')) {
        _isDarkMode = _prefs.getBool('is_dark_mode') ?? false;
      } else {
        _isDarkMode = false;
        await _prefs.setBool('is_dark_mode', _isDarkMode);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi truy vấn chế độ tối: ${e.toString()}');
    }
  }

  Future<void> setDarkMode(bool value) async {
    try {
      _isDarkMode = value;
      await _prefs.setBool('is_dark_mode', value);
      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi khi chuyển sang chế độ tối: ${e.toString()}');
    }
  }
}
