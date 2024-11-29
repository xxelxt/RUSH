class ValidationType {
  // Singleton
  ValidationType._privateConstructor();
  static final ValidationType _instance = ValidationType._privateConstructor();
  static ValidationType get instance => _instance;

  // Alert Value
  final String _alertEmptyField = 'You must fill this field';
  final String _alertEmailIsNotValid = 'Email address is not valid';
  final String _alertPasswordLength = 'Password must be at least more than 6 characters';
  final String _alertConfirmPassword = 'Confirm Password not match with Password';
  final String _alertCardNumberLength = 'Payment card numbers are composed of 8 to 19 digits';
  final String _alertCvvLength = 'CVV are 3 to 4 digits number printed on your credit card';
  final String _alertPhoneNumberLength = 'Phone number must be at least more than 10 characters';

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
