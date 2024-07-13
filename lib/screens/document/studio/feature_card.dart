import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Contains the visual aspect of the card that displays the features of the AI Studio.
class FeatureCard extends StatelessWidget {
  /// Creates a [FeatureCard]
  const FeatureCard({
    required this.icon,
    required this.title,
    required this.width,
    required this.height,
    super.key,
  });

  /// Contains the icon of the feature
  final String icon;

  /// Contains the title of the feature
  final String title;

  /// Contains the width of the card
  final double? width;

  /// Contains the height of the card
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Spacer(),
          SvgPicture.asset(
            icon,
            width: 48,
            height: 48,
          ),
          // const SizedBox(height: 8),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
