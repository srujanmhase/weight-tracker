import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension FontsX on BuildContext {
  TextStyle get paragraph => GoogleFonts.playfairDisplay(fontSize: 18);
  TextStyle get title => GoogleFonts.playfairDisplay(fontSize: 24);

  TextStyle get h1 => GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w200,
      );

  TextStyle get h2 => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w200,
      );

  TextStyle get xtraLight => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w200,
      );
}
