import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rush/app/providers/dark_mode_provider.dart';

import 'dark_mode_provider_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late DarkModeProvider darkModeProvider;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();

    // Sử dụng SharedPreferences giả lập trong các bài test
    SharedPreferences.setMockInitialValues({});
    darkModeProvider = DarkModeProvider();
  });

  group('DarkModeProvider', () {
    test('Should initialize dark mode as false when no value is stored', () async {
      // Không có giá trị được lưu trữ trong SharedPreferences
      SharedPreferences.setMockInitialValues({});

      await darkModeProvider.getDarkMode();

      expect(darkModeProvider.isDarkMode, false);
    });

    test('Should load stored dark mode value as true', () async {
      // Giá trị được lưu trữ trong SharedPreferences là true
      SharedPreferences.setMockInitialValues({'is_dark_mode': true});

      await darkModeProvider.getDarkMode();

      expect(darkModeProvider.isDarkMode, true);
    });

    test('Should set dark mode to true and save to SharedPreferences', () async {
      await darkModeProvider.setDarkMode(true);

      expect(darkModeProvider.isDarkMode, true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_dark_mode'), true);
    });

    test('Should set dark mode to false and save to SharedPreferences', () async {
      await darkModeProvider.setDarkMode(false);

      expect(darkModeProvider.isDarkMode, false);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_dark_mode'), false);
    });
  });
}
