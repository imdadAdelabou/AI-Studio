import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A function to create a snackBar
SnackBar customSnackBar({required String content, bool isError = false}) {
  return SnackBar(
    width: 350,
    content: Text(
      content,
      style: GoogleFonts.lato(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    ),
    backgroundColor: isError ? Colors.red : Colors.green,
    behavior: SnackBarBehavior.floating,
  );
}
