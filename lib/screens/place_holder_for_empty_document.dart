import 'package:docs_ai/utils/app_assets.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

/// A placeholder widget to display when there is no document
class PlaceHolderForEmptyDocument extends StatelessWidget {
  /// Creates a [PlaceHolderForEmptyDocument] widget
  const PlaceHolderForEmptyDocument({super.key});

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.sizeOf(context).height;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            AppAssets.emptyDocIllustration,
            height: MediaQuery.sizeOf(context).width > 480
                ? maxHeight * .3
                : maxHeight * .2,
          ),
          const Gap(10),
          Text(
            AppText.noDocumentYet,
            style: GoogleFonts.lato(
              fontSize: MediaQuery.sizeOf(context).width > 480 ? 24 : 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
