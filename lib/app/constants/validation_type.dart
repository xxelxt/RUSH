class ValidationType {
  // Constructor private, ngăn việc tạo instance từ bên ngoài
  ValidationType._privateConstructor();

  // Khởi tạo instance duy nhất của lớp
  static final ValidationType _instance = ValidationType._privateConstructor();

  // Getter để truy cập instance duy nhất từ bên ngoài
  static ValidationType get instance => _instance;

  final String _alertEmptyField = 'Vui lòng điền vào trường này';
  final String _alertEmailIsNotValid = 'Địa chỉ email không hợp lệ';
  final String _alertPasswordLength = 'Mật khẩu cần dài ít nhất 6 ký tự';
  final String _alertConfirmPassword = 'Mật khẩu nhập lại không trùng';
  final String _alertCardNumberLength = 'Nhập thẻ thanh toán dài từ 8 đến 19 chữ số';
  final String _alertCvvLength = 'Nhập số CVV dài 3 hoặc 4 chữ số phía sau thẻ của bạn';
  final String _alertPhoneNumberLength = 'Nhập số điện thoại có ít nhất 10 chữ số';

  String? emailValidation(String? value) {
    RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    if (!emailRegex.hasMatch(value)) {
      return _alertEmailIsNotValid;
    }

    return null;
  }

  String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    if (value.length < 6) {
      return _alertPasswordLength;
    }

    return null;
  }

  String? emptyValidation(String? value) {
    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    return null;
  }

  String? confirmPasswordValidation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    if (value != password) {
      return _alertConfirmPassword;
    }

    return null;
  }

  String? phoneNumberValidation(String? value) {
    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    if (value.length < 10) {
      return _alertPhoneNumberLength;
    }

    return null;
  }

  String? cardNumberValidation(String? value) {
    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    if (value.length < 8) {
      return _alertCardNumberLength;
    }

    return null;
  }

  String? cvvValidation(String? value) {
    if (value == null || value.isEmpty) {
      return _alertEmptyField;
    }

    if (value.length < 3) {
      return _alertCvvLength;
    }

    return null;
  }
}
