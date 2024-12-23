import 'dart:math';
import 'package:intl/intl.dart';

import '../app/constants/country_code.dart';

extension StringExtension on String {
  // Tạo mã UID ngẫu nhiên gồm 20 ký tự
  String generateUID() {
    const int length = 20;
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    const int maxRandom = alphabet.length;
    final Random randomGen = Random();

    final StringBuffer buffer = StringBuffer(); // Chuỗi tạm lưu các ký tự
    for (int i = 0; i < length; i++) {
      buffer.write(alphabet[randomGen.nextInt(maxRandom)]); // Thêm ký tự ngẫu nhiên vào chuỗi
    }

    return buffer.toString();
  }

  // Viết hoa chữ cái đầu của mỗi từ và tách PascalCase
  String capitalizeFirstLetter() {
    // Regex tách PascalCase trước mỗi chữ cái in hoa (trừ chữ đầu tiên)
    final beforeNonLeadingCapitalLetter = RegExp(r"(?=(?!^)[A-Z])");

    // Hàm chia chuỗi PascalCase thành các phần nhỏ
    List<String> splitPascalCase(String input) => input.split(beforeNonLeadingCapitalLetter);

    List<String> data = splitPascalCase(this);

    String text = '';

    if (data.length > 1) {
      // Viết hoa chữ cái đầu của từng từ (nếu có nhiều từ)
      for (var element in data) {
        text += '${element[0].toUpperCase()}${element.substring(1).toLowerCase()} ';
      }
    } else {
      // Nếu chỉ có một từ
      text += '${data.first[0].toUpperCase()}${data.first.substring(1).toLowerCase()}';
    }

    return text;
  }

  // Tách mã quốc gia và số điện thoại
  String separateCountryCode() {
    String phoneNumber = '';
    String countryCode = '';

    // Duyệt qua danh sách mã quốc gia
    for (var element in CountryCode.dataCountryCode) {
      String code = element[2];
      String codeTelp = substring(0, code.length);
      if (codeTelp.contains(code)) {
        phoneNumber = substring(code.length);
        countryCode = code;
        break;
      }
    }

    String result = '+$countryCode $phoneNumber';

    return result;
  }
}

extension DoubleExtension on double {
  String toCurrency() {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(this); // Định dạng theo USD
  }
}

extension IntExtension on int {
  String toNumericFormat() {
    return NumberFormat("#,###").format(this);
  }
}
