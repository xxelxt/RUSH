import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Nếu người dùng xóa toàn bộ nội dung, trả về chuỗi rỗng
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Nếu giá trị mới khác với giá trị cũ
    else if (newValue.text.compareTo(oldValue.text) != 0) {
      // Tính vị trí con trỏ so với cuối chuỗi
      final int selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;

      // Sử dụng `NumberFormat` để định dạng số với dấu phân cách hàng nghìn
      final f = NumberFormat("#,###");

      // Chuyển đổi chuỗi nhập vào thành số nguyên (loại bỏ dấu phân cách)
      final number = int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));

      // Định dạng số thành chuỗi có dấu phân cách
      final newString = f.format(number);

      // Trả về giá trị mới với chuỗi định dạng và con trỏ ở đúng vị trí
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length - selectionIndexFromTheRight),
      );
    }

    // Nếu giá trị không thay đổi, giữ nguyên giá trị cũ
    else {
      return newValue;
    }
  }
}
