// import 'package:flutter/material.dart';

// //light theme
// ThemeData lightMode = ThemeData(
//     brightness: Brightness.light,
//     colorScheme: ColorScheme.light(
//         surface: Colors.grey.shade300,
//         primary: Colors.grey.shade200,
//         secondary: Colors.grey.shade400,
//         inversePrimary: Colors.grey.shade800));

// //dark mode
// ThemeData darkMode = ThemeData(
//     brightness: Brightness.dark,
//     colorScheme: ColorScheme.dark(
//         surface: Colors.grey.shade900,
//         primary: Colors.grey.shade800,
//         secondary: Colors.grey.shade700,
//         inversePrimary: Colors.grey.shade300));

import 'package:flutter/material.dart';

// Light theme
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.blue, // Primary color for buttons
    secondary: Colors.green, // Secondary color for buttons
    onPrimary: Colors.white, // Text color on primary buttons
    onSecondary: Colors.white, // Text color on secondary buttons
    error: Colors.red, // Error color
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black), // Default body text color
    bodyMedium: TextStyle(color: Colors.black),
    displaySmall: TextStyle(color: Colors.black), // Secondary body text color
    displayLarge: TextStyle(color: Colors.black), // Headline 1 text color
    displayMedium: TextStyle(color: Colors.black),
    // Headline 2 text color
    // Add more text styles as needed
  ),
  //floating action button
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: Colors.black),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, foregroundColor: Colors.black)),

  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.grey.shade300,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.blue, // Primary color for buttons
    secondary: Colors.green, // Secondary color for buttons
    error: Colors.redAccent, // Error color
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white), // Default body text color
    bodyMedium: TextStyle(color: Colors.white),
    displaySmall: TextStyle(color: Colors.white), // Secondary body text color
    displayLarge: TextStyle(color: Colors.white), // Headline 1 text color
    displayMedium: TextStyle(color: Colors.white), // Headline 2 text color
    // Add more text styles as needed
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white, foregroundColor: Colors.black),
  appBarTheme: AppBarTheme(
    backgroundColor:
        Colors.grey.shade800, // Set AppBar background color to black
    elevation: 0, // Optional: remove shadow if needed
  ),
);
