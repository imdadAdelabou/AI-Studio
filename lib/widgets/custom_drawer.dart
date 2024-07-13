import 'dart:async';
import 'dart:developer';

import 'package:docs_ai/models/pricing.dart';
import 'package:docs_ai/models/user.dart';
import 'package:docs_ai/repository/auth_repository.dart';
import 'package:docs_ai/screens/pricing/pricing_view.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/colors.dart';
import 'package:docs_ai/widgets/close_dialog_icon.dart';
import 'package:docs_ai/widgets/type_pricing_view.dart';
import 'package:docs_ai/widgets/user_data.display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom drawer to display the user data and other information
class CustomDrawer extends ConsumerWidget {
  /// Creates a [CustomDrawer] widget
  const CustomDrawer({super.key});

  void _showDialog(BuildContext context) {
    log(MediaQuery.sizeOf(context).width.toString());
    unawaited(
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: const CloseDialogIcon(),
            content: const PricingView(),
            insetPadding: const EdgeInsets.symmetric(
              vertical: 30,
            ),
            backgroundColor: kDialogColor,
            surfaceTintColor: kDialogColor,
            scrollable: true,
            title: Text(
              AppText.pricing,
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel? user = ref.watch(userProvider);
    final Pricing currentPricing = user!.getPricing;

    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Column(
        children: <Widget>[
          const Gap(20),
          UserDataDisplay(
            userModel: user,
          ),
          const Gap(8),
          TypePriciningView(
            label: currentPricing.label,
            labelColor: currentPricing.labelColor,
          ),
          const Gap(20),
          ListTile(
            title: Text(
              AppText.pricing,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
