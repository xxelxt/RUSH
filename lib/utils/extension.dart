import 'dart:math';

import 'package:intl/intl.dart';

import '../app/constants/country_code.dart';

extension StringExtension on String {
  String generateUID() {
    const int length = 20;
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    const int maxRandom = alphabet.length;
    final Random randomGen = Random();

    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      buffer.write(alphabet[randomGen.nextInt(maxRandom)]);
    }

    return buffer.toString();
  }

  String capitalizeFirstLetter() {
    // Matches before a capital letter that is not also at beginning of string.
    final beforeNonLeadingCapitalLetter = RegExp(r"(?=(?!^)[A-Z])");
    List<String> splitPascalCase(String input) => input.split(beforeNonLeadingCapitalLetter);

    List<String> data = splitPascalCase(this);

    String text = '';


    if (data.length > 1) {
      for (var element in data) {
        text += '${element[0].toUpperCase()}${element.substring(1).toLowerCase()}';
        text += ' ';
      }
    } else {
      text += '${data.first[0].toUpperCase()}${data.first.substring(1).toLowerCase()}';
    }

    return text;
  }

  String separateCountryCode() {
    String phoneNumber = '';
    String countryCode = '';

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
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(this);
  }
}

extension IntExtension on int {
  String toNumericFormat() {
    return NumberFormat("#,###").format(this);
  }
}
