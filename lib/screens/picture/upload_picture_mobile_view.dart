import 'dart:async';
import 'dart:io';

import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/models/user.dart';
import 'package:docs_ai/repository/auth_repository.dart';
import 'package:docs_ai/repository/firebase_storage_repository.dart';
import 'package:docs_ai/repository/image_picker_repository.dart';
import 'package:docs_ai/repository/user.repository.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/colors.dart';
import 'package:docs_ai/widgets/custom_btn.dart';
import 'package:docs_ai/widgets/custom_snack_bar.dart';
import 'package:docs_ai/widgets/show_remote_profile_pic.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routemaster/routemaster.dart';

/// The widgets that contains the layout to display on mobile device
class UploadPictureMobileView extends ConsumerStatefulWidget {
  /// Creates a [UploadPictureMobileView] instance
  const UploadPictureMobileView({
    super.key,
    this.showDescriptionText = false,
    this.width,
  });

  /// Used to display or not the description text
  final bool showDescriptionText;

  /// Used to define a custom width to the upload button
  final double? width;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UploadPictureMobileViewState();
}

class _UploadPictureMobileViewState
    extends ConsumerState<UploadPictureMobileView> {
  dynamic _pickedFile;
  bool _isLoading = false;

  Future<void> _pickFile(WidgetRef ref) async {
    if (kIsWeb) {
      final FilePickerResult? result =
          await ref.read(imagePickerRepositoryProvider).pickImageFromWeb();
      if (result != null) {
        _pickedFile = result.files.first;
      }
    } else {
      final XFile? file =
          await ref.read(imagePickerRepositoryProvider).pickImageFromGallery();
      if (file != null) {
        _pickedFile = File(file.path);
      }
    }

    setState(() {});
  }

  Future<void> _uploadHandle(WidgetRef ref) async {
    final ScaffoldMessengerState scaffolfMessenger =
        ScaffoldMessenger.of(context);
    void goToHome() => Routemaster.of(context).replace('/');
    setState(() {
      _isLoading = true;
    });
    String fileName = '';
    if (kIsWeb && _pickedFile is PlatformFile) {
      fileName = FileNameForFileForPlatformFile(file: _pickedFile).getName();
    } else {
      fileName = FileNameForFile(file: _pickedFile).getName();
    }

    final dynamic pictureUrl =
        await ref.read(firebaseStorageRepositoryProvider).uploadFile(
              path: 'images/',
              file: _pickedFile!,
              fileName: fileName,
            );
    if (pictureUrl is bool) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      scaffolfMessenger.showSnackBar(
        customSnackBar(
          content: AppText.errorHappenedUploadImage,
          isError: true,
        ),
      );
      return;
    }
    final ErrorModel result = await ref.read(userRepositoryProvider).update(
      data: <String, String>{
        'photoUrl': pictureUrl,
      },
    );
    setState(() {
      _isLoading = false;
    });
    ref.read(userProvider.notifier).update(
          (_) => result.data,
        );

    ///Upate profile pic on backend
    goToHome();
  }

  ImageProvider<Object>? _returnTheRightImage() {
    if (_pickedFile == null) {
      return null;
    }

    if (kIsWeb) {
      return Image.memory((_pickedFile as PlatformFile).bytes!).image;
    }

    return FileImage(_pickedFile);
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? userModel = ref.watch(userProvider);

    return Center(
      child: Column(
        children: <Widget>[
          const Gap(20),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Routemaster.of(context).replace('/'),
                child: Text(
                  AppText.skip,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const Gap(30),
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              if (userModel != null &&
                  userModel.photoUrl.isNotEmpty &&
                  _pickedFile == null)
                ShowRemoteProfilPic(
                  url: userModel.photoUrl,
                )
              else
                CircleAvatar(
                  radius: 70,
                  backgroundImage: _returnTheRightImage(),
                ),
              Positioned(
                bottom: -18,
                left: 50,
                child: IconButton(
                  onPressed: () => unawaited(
                    _pickFile(ref),
                  ),
                  icon: const Icon(
                    Icons.add,
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                      (_) => kWhiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(40),
          Visibility(
            visible: widget.showDescriptionText,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppText.descriptionOnUploadPicture,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: kGreyColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomBtn(
              width: widget.width,
              isLoading: _isLoading,
              label: AppText.upload,
              onPressed: _pickedFile != null
                  ? () => unawaited(_uploadHandle(ref))
                  : null,
            ),
          ),
          const Gap(50),
        ],
      ),
    );
  }
}
