import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget to display the type of pricing
class TypePriciningView extends StatelessWidget {
  /// Creates a [TypePriciningView] widget
  const TypePriciningView({
    required this.label,
    required this.labelColor,
    super.key,
  });

  /// The label of the pricing
  final String label;

  /// The color of the label
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: labelColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
