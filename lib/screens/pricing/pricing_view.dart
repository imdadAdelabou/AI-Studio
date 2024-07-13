import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/models/pricing.dart';
import 'package:docs_ai/repository/auth_repository.dart';
import 'package:docs_ai/repository/pricing_repository.dart';
import 'package:docs_ai/repository/stripe_repository.dart';
import 'package:docs_ai/screens/pricing/get_started_btn.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/colors.dart';
import 'package:docs_ai/viewModels/pricing_viewmodel.dart';
import 'package:docs_ai/widgets/custom_btn.dart';
import 'package:docs_ai/widgets/custom_snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class _ErrorPricingFetchingWidget extends StatelessWidget {
  const _ErrorPricingFetchingWidget({
    required this.error,
  });

  final String error;

  @override
  Widget build(BuildContext context) {
    return Text(
      error,
      style: GoogleFonts.lato(
        color: kBlackColor,
      ),
    );
  }
}

/// A widget to display the pricing card
class PricingCard extends ConsumerWidget {
  /// Creates a [PricingCard] widget
  const PricingCard({
    required this.pricing,
    required this.width,
    required this.height,
    this.isCurrentPricing = false,
    super.key,
  });

  /// To know if the current pricing is the current pricing
  final bool isCurrentPricing;

  /// The pricing model
  final Pricing pricing;

  /// The width of the card
  final double width;

  /// The height of the card
  final double? height;

  Future<void> _makePayment({
    required WidgetRef ref,
    required Pricing pricing,
    required BuildContext context,
  }) async {
    final NavigatorState navigator = Navigator.of(context);
    final ScaffoldMessengerState scaffoldMessanger =
        ScaffoldMessenger.of(context);
    final bool result =
        await ref.read(stripeRepositoryProvider).stripeMakePayment(
              amount: pricing.price.toInt() * 100,
              currency: 'USD',
            );
    log(result.toString());
    if (result) {
      try {
        await Stripe.instance.presentPaymentSheet();
        final bool result = await PricingViewModel().updateUserPricing(
          pricingId: pricing.id,
          ref: ref,
        );
        if (result) {
          navigator
            ..pop()
            ..pop();
          scaffoldMessanger
              .showSnackBar(customSnackBar(content: AppText.paymentSucessful));
        }
      } on Exception catch (e) {
        if (e is StripeException) {
          scaffoldMessanger.showSnackBar(
            customSnackBar(
              content: e.error.localizedMessage!,
              isError: true,
            ),
          );
        } else {
          scaffoldMessanger.showSnackBar(
            customSnackBar(
              content: AppText.errorHappened,
              isError: true,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        color: kPriceCardBg,
        surfaceTintColor: kPriceCardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isCurrentPricing ? kBlueColor : kPriceCardBg,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                pricing.label,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: kBlackColor,
                ),
              ),
              const Gap(4),
              Text(
                '${pricing.price}\$',
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(8),
              Text(
                pricing.description,
                style: GoogleFonts.lato(
                  color: kDescriptionColor,
                ),
              ),
              ...pricing.advantages.map(
                (String advantage) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.check,
                        color: kBlackColor,
                        size: 16,
                      ),
                      const Gap(4),
                      SizedBox(
                        width: width * .7,
                        child: AutoSizeText(
                          advantage,
                          style: GoogleFonts.lato(
                            color: kBlackColor,
                          ),
                          maxFontSize: 14,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(18),
              const Spacer(),
              Visibility(
                visible: !isCurrentPricing && !kIsWeb,
                child: GetStartedBtn(
                  onPressed: () => unawaited(
                    _makePayment(
                      ref: ref,
                      pricing: pricing,
                      context: context,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isCurrentPricing,
                child: Align(
                  child: Text(
                    AppText.currentPlan,
                    style: GoogleFonts.lato(
                      color: kBlueColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Visibility(
                visible: !isCurrentPricing && kIsWeb,
                child: Align(
                  child: Text(
                    AppText.changePlanOnMobile,
                    style: GoogleFonts.lato(
                      color: kRedColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Contains the visual aspect of the pricing page
class PricingView extends ConsumerWidget {
  /// Creates a [PricingView] widget
  const PricingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MediaQuery.of(context).size.width > 480
        ? const _PricingViewForLargeScreen()
        : const _PricingViewMobileScreen();
  }
}

/// Contains the visual aspect of the pricing page for large screen
class _PricingViewForLargeScreen extends ConsumerWidget {
  /// Creates a [PricingViewForLargeScreen] widget
  const _PricingViewForLargeScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final AsyncValue<ErrorModel> errorModel =
                  ref.watch(getPricingProvider);

              return Center(
                child: switch (errorModel) {
                  AsyncData<ErrorModel>(:final ErrorModel value) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (value.data as List<Pricing>)
                          .map(
                            (Pricing pricing) => PricingCard(
                              pricing: pricing,
                              height: 300,
                              width:
                                  (MediaQuery.sizeOf(context).width * .8) / 2,
                              isCurrentPricing: pricing.id ==
                                  ref.watch(userProvider)?.getPricing.id,
                            ),
                          )
                          .toList(),
                    ),
                  AsyncError<Widget>() => _ErrorPricingFetchingWidget(
                      error: errorModel.error.toString(),
                    ),
                  _ => const CustomCircularProgressIndicator(),
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PricingViewMobileScreen extends ConsumerWidget {
  const _PricingViewMobileScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final AsyncValue<ErrorModel> errorModel =
                ref.watch(getPricingProvider);

            return switch (errorModel) {
              AsyncData<ErrorModel>(:final ErrorModel value) => Column(
                  children: (value.data as List<Pricing>)
                      .map(
                        (Pricing pricing) => PricingCard(
                          pricing: pricing,
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height * .5,
                          isCurrentPricing: pricing.id ==
                              ref.watch(userProvider)?.getPricing.id,
                        ),
                      )
                      .toList(),
                ),
              AsyncError<Widget>() => _ErrorPricingFetchingWidget(
                  error: errorModel.error.toString(),
                ),
              _ => const CustomCircularProgressIndicator(),
            };
          },
        ),
        const Gap(20),
      ],
    );
  }
}
