import 'package:flutter/services.dart';

class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    String valueToReturn = '';

    for (int i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != '/') {
        // Nếu ký tự không phải '/', thêm vào chuỗi kết quả
        valueToReturn += newValueString[i];
      }

      var nonZeroIndex = i + 1;

      // Kiểm tra nếu vị trí là số chẵn, chưa phải ký tự cuối, và chưa chứa '/'
      final contains = valueToReturn.contains(RegExp(r'\/')); // Kiểm tra nếu đã có dấu '/'
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newValueString.length && !contains) {
        valueToReturn += '/'; // Thêm dấu '/' vào sau 2 ký tự
      }
    }

    // Trả về giá trị mới với chuỗi đã định dạng và đặt lại vị trí con trỏ
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(
        TextPosition(offset: valueToReturn.length),
      ),
    );
  }
}
