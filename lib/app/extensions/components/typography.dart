import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../drap_and_drop/color.dart';

// Simple
TextStyle headlineTextStyle = GoogleFonts.montserrat(textStyle: const TextStyle( fontSize: 26,color: textPrimary,letterSpacing: 1.5,fontWeight: FontWeight.w300));

TextStyle headlineSecondaryTextStyle = GoogleFonts.montserrat(textStyle: const TextStyle(fontSize: 20, color: textPrimary, fontWeight: FontWeight.w300));

TextStyle bookDetailTextStyle = GoogleFonts.montserrat(textStyle: const TextStyle(fontSize: 25, color: textDetail, fontWeight: FontWeight.w500));
TextStyle bookDetailMobileTextStyle = GoogleFonts.montserrat(textStyle: const TextStyle(fontSize: 12, color: textDetail, fontWeight: FontWeight.w500));

TextStyle subtitleTextStyle = GoogleFonts.openSans( textStyle: const TextStyle(fontSize: 14, color: textSecondary, letterSpacing: 1));

TextStyle bodyTextStyle = GoogleFonts.openSans(textStyle: const TextStyle(fontSize: 14, color: textPrimary));

TextStyle buttonTextStyle = GoogleFonts.montserrat(textStyle: const TextStyle(fontSize: 14, color: textPrimary, letterSpacing: 1));
TextStyle buttonPrimaryTextStyle = GoogleFonts.montserrat(textStyle: const TextStyle(fontSize: 20, color: textPrimary, letterSpacing: 1));
TextStyle get subHeadingStyle {
  return TextStyle(
      fontSize: 18,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
      fontWeight: FontWeight.bold);
}

TextStyle get headingStyle {
  return TextStyle(
      fontSize: 30,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
      fontWeight: FontWeight.bold);
}

TextStyle get subTitleStyle {
  return TextStyle(
      fontSize: 25,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
      fontWeight: FontWeight.bold);
}
TextStyle get subTitleMobileStyle {
  return TextStyle(
      fontSize: 16,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
      fontWeight: FontWeight.bold);
}
TextStyle get subTitleMobieStyle {
  return TextStyle(
      fontSize: 16,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
      fontWeight: FontWeight.bold);
}
TextStyle get titleStyle {
  return TextStyle(
      fontSize: 25,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
      fontWeight: FontWeight.bold);
}
// Advanced
// TODO: Add additional text styles.
