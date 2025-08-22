import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const Color bluishClr = Color(0xFF4e5ae9);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const Color darkGreyClr = Color(0xFF424242); //Color(0xFF121212)
const Color darkHeaderClr = Color(0xFF424242);
const PrimaryClr = bluishClr;

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(primary: Colors.white),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(primary: darkGreyClr),
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
    ),
  );
}

TextStyle get HeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    color: Get.isDarkMode ? Colors.white : Colors.black,
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    color: Get.isDarkMode ? Colors.white : Colors.black,
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
  );
}
