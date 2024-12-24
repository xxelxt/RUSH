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
    darkModeProvider = DarkModeProvider(mockSharedPreferences);
  });

  group('DarkModeProvider', () {
    test('Should initialize dark mode as false when no value is stored', () async {
      when(mockSharedPreferences.containsKey('is_dark_mode')).thenReturn(false);
      when(mockSharedPreferences.setBool('is_dark_mode', false))
          .thenAnswer((_) async => true);

      await darkModeProvider.getDarkMode();

      expect(darkModeProvider.isDarkMode, false);
      verify(mockSharedPreferences.containsKey('is_dark_mode')).called(1);
      verify(mockSharedPreferences.setBool('is_dark_mode', false)).called(1);
    });

    test('Should load stored dark mode value as true', () async {
      when(mockSharedPreferences.containsKey('is_dark_mode')).thenReturn(true);
      when(mockSharedPreferences.getBool('is_dark_mode')).thenReturn(true);

      await darkModeProvider.getDarkMode();

      expect(darkModeProvider.isDarkMode, true);
      verify(mockSharedPreferences.containsKey('is_dark_mode')).called(1);
      verify(mockSharedPreferences.getBool('is_dark_mode')).called(1);
    });

    test('Should set dark mode to true and save to SharedPreferences', () async {
      when(mockSharedPreferences.setBool('is_dark_mode', true))
          .thenAnswer((_) async => true);

      await darkModeProvider.setDarkMode(true);

      expect(darkModeProvider.isDarkMode, true);
      verify(mockSharedPreferences.setBool('is_dark_mode', true)).called(1);
    });

    test('Should set dark mode to false and save to SharedPreferences', () async {
      when(mockSharedPreferences.setBool('is_dark_mode', false))
          .thenAnswer((_) async => true);

      await darkModeProvider.setDarkMode(false);

      expect(darkModeProvider.isDarkMode, false);
      verify(mockSharedPreferences.setBool('is_dark_mode', false)).called(1);
    });
  });
}
