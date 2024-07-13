import 'package:docs_ai/screens/picture/upload_picture_mobile_view.dart';
import 'package:docs_ai/utils/app_assets.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Contains the screen to display when the user is on the large screen
class UploadPictureLargeView extends ConsumerWidget {
  /// Creates a [UploadPictureLargeView] instance
  const UploadPictureLargeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ColoredBox(
            color: kBlueColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  AppAssets.uploadingImage,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2 * .7,
                  child: Text(
                    AppText.descriptionOnUploadPicture,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: kWhiteColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: UploadPictureMobileView(
            width: MediaQuery.sizeOf(context).width / 2 * .5,
          ),
        ),
      ],
    );
  }
}
