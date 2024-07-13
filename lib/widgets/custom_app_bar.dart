import 'dart:async';
import 'dart:developer';

import 'package:docs_ai/models/document_model.dart';
import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/repository/auth_repository.dart';
import 'package:docs_ai/repository/document_repository.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/colors.dart';
import 'package:docs_ai/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:routemaster/routemaster.dart';

/// The appBar of the home page
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  /// Creates a [CustomAppBar] widget
  const CustomAppBar({
    super.key,
    this.height = kTextTabBarHeight,
  });

  /// A parameter to manage the height of the AppBar
  final double height;

  /// A function to trigger the function to create a document
  /// And redirect to the document screen created
  /// otherwise display a snack bar with an error message
  Future<void> createDocument(BuildContext context, WidgetRef ref) async {
    final String token = ref.read(userProvider)!.token;
    final Routemaster navigator = Routemaster.of(context);
    final ScaffoldMessengerState snackBar = ScaffoldMessenger.of(context);

    final ErrorModel errorModel =
        await ref.read(documentRepositoryProvider).createDocument(token);
    if (errorModel.data != null) {
      navigator.push('/document/${(errorModel.data as DocumentModel).id}');
      return;
    }
    log(errorModel.error!);
    snackBar.showSnackBar(
      customSnackBar(
        content: AppText.errorHappened,
        isError: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          color: kBlackColor,
          onPressed: () => unawaited(createDocument(context, ref)),
        ),
        const Gap(20),
        IconButton(
          icon: const Icon(Icons.settings),
          color: kBlackColor,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        const Gap(20),
        IconButton(
          icon: const Icon(Icons.logout),
          color: kRedColor,
          onPressed: () =>
              unawaited(ref.read(authRepositoryProvider).signOut()),
        ),
        const Gap(20),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
