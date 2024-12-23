import 'package:flutter/services.dart';

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var inputText = newValue.text;

    // Nếu vị trí con trỏ là 0, trả về giá trị mới mà không thay đổi
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var bufferString = StringBuffer(); // Sử dụng StringBuffer để xây dựng chuỗi mới
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]); // Thêm ký tự hiện tại vào chuỗi
      var nonZeroIndexValue = i + 1;

      // Thêm khoảng trắng sau mỗi 4 ký tự trừ khi là ký tự cuối cùng
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString(); // Chuyển StringBuffer thành chuỗi
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
