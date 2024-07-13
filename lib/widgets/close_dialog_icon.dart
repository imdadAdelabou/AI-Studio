import 'package:docs_ai/utils/colors.dart';
import 'package:flutter/material.dart';

/// Contains the close dialog icon
class CloseDialogIcon extends StatelessWidget {
  /// Creates a [CloseDialogIcon]
  const CloseDialogIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: const Align(
        alignment: Alignment.topRight,
        child: Icon(
          Icons.close,
          color: kBlackColor,
        ),
      ),
    );
  }
}
