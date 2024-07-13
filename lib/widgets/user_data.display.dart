import 'package:docs_ai/models/user.dart';
import 'package:docs_ai/utils/app_assets.dart';
import 'package:docs_ai/widgets/show_remote_profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget to display some user information(image profile, name and email)
class UserDataDisplay extends StatelessWidget {
  /// Creates a [UserDataDisplay] widget
  const UserDataDisplay({
    required this.userModel,
    super.key,
  });

  /// Contains the user data
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (userModel.photoUrl.isEmpty)
          CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage(AppAssets.avatarPlaceHolder),
          )
        else
          ShowRemoteProfilPic(url: userModel.photoUrl),
        const Gap(4),
        Text(
          userModel.name,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const Gap(4),
        Text(
          userModel.email,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
