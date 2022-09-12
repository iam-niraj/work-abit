import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const Color primaryClr = Colors.teal;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final darkTheme = ThemeData(
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.amber,
      disabledColor: Colors.grey,
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: darkGreyClr,
      secondary: darkHeaderClr,
    ),
  );

  static final lightTheme = ThemeData(
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
      disabledColor: Colors.grey,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: Colors.teal,
      secondary: Colors.pink,
    ),
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.satisfy(
    textStyle: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFF63d4c0), /* Get.isDarkMode ? Colors.grey[400] : */
    ),
  );
}

TextStyle get headingStyle {
  return GoogleFonts.pacifico(
    textStyle: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Color(0xFF6fddaf),
    ),
  ); /* Get.isDarkMode ? Colors.black : */
}

TextStyle get headingStyle1 {
  return GoogleFonts.satisfy(
    textStyle: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Color(0xFF6fddaf),
    ),
  ); /* Get.isDarkMode ? Colors.black : */
}

TextStyle get titleStyle {
  return GoogleFonts.satisfy(
    textStyle: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: Get.isDarkMode ? Colors.white : Color(0xFF7fffd4),
    ),
  );
}

TextStyle get subtitleStyle {
  return GoogleFonts.satisfy(
    textStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[400],
    ),
  );
}

TextStyle get buttontitleStyle {
  return GoogleFonts.satisfy(
    textStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Color(0xFF7fffd4),
    ),
  );
}

extension PercentSized on double {
  double get hp => (Get.height * (this / 100));
  double get wp => (Get.width * (this / 100));
}

extension ResponsiveText on double {
  double get sp => Get.width / 100 * (this / 3);
}
