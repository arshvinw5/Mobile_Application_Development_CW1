// Import your theme definitions

import 'package:flutter/material.dart';
import 'package:note_app/services/database_helper.dart';
import 'package:note_app/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  // Initial theme is light mode
  ThemeData _themeData = lightMode;

  ThemeProvider() {
    _loadTheme();
  }

  // Getter method to access the theme from other parts of the code
  ThemeData get themeData => _themeData;

  // Getter method to see if we are in dark mode or not
  bool get isDarkMode => _themeData == darkMode;

  // Setter method to set the new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // We will use this toggle in a switch later on
  // void toggleTheme() {
  //   if (_themeData == lightMode) {
  //     themeData = darkMode; // Switch to dark theme
  //   } else {
  //     themeData = lightMode; // Switch to light theme
  //   }
  // }

  void toggleTheme() {
    themeData = isDarkMode ? lightMode : darkMode;
    _saveThemeSetting();
  }

  // Load theme from database
  Future<void> _loadTheme() async {
    final isDarkMode = await DatabaseHelper.instance.loadThemeSetting();
    themeData = isDarkMode ? darkMode : lightMode;
  }

  // Save theme setting in database
  Future<void> _saveThemeSetting() async {
    await DatabaseHelper.instance.saveThemeSetting(isDarkMode);
  }
}
