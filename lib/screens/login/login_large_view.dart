import 'package:docs_ai/screens/login/model.dart';
import 'package:docs_ai/utils/app_assets.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/colors.dart';
import 'package:docs_ai/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';

final List<OnBoardingItemModel> _onBoardingItems = <OnBoardingItemModel>[
  OnBoardingItemModel(
    title: 'Collaborative',
    description: AppText.collaborativeDescription,
    icon: AppAssets.collaborativeIllustration,
  ),
  OnBoardingItemModel(
    title: AppText.easyToUseTitle,
    description: AppText.easyToUseDescription,
    icon: AppAssets.easyToUseIllustration,
  ),
  OnBoardingItemModel(
    title: AppText.ai,
    description: AppText.aiDescription,
    icon: AppAssets.aiIllustration,
  ),
];

class _OnBoardingView extends StatelessWidget {
  const _OnBoardingView({
    required this.item,
    this.width,
    this.iconHeight,
    this.descriptionFontSize = 18,
    this.titleFontSize = 34,
  });

  final OnBoardingItemModel item;
  final double? width;

  final double? iconHeight;

  final double titleFontSize;

  final double descriptionFontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SvgPicture.asset(
              item.icon,
              height: iconHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  item.title,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w700,
                    fontSize: 34,
                    color: kWhiteColor,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: Text(
                    item.description,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w400,
                      fontSize: descriptionFontSize,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The widget to display on mobile screen for the onboarding screen
class OnBoardingForMobile extends StatefulWidget {
  /// Creates a [OnBoardingForMobile] widget
  const OnBoardingForMobile({super.key});

  @override
  State<OnBoardingForMobile> createState() => _OnBoardingForMobileState();
}

class _OnBoardingForMobileState extends State<OnBoardingForMobile> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.sizeOf(context).height;
    return Column(
      children: <Widget>[
        const Gap(20),
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () => Routemaster.of(context).replace('/login-mobile'),
            child: Text(
              AppText.skip,
              style: GoogleFonts.lato(
                color: kWhiteColor,
                fontSize: 14,
              ),
            ),
          ),
        ),
        Expanded(
          child: PageView.builder(
            itemCount: _onBoardingItems.length,
            onPageChanged: (int value) => setState(() {
              _currentIndex = value;
            }),
            itemBuilder: (BuildContext context, int index) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _OnBoardingView(
                  item: _onBoardingItems[index],
                  iconHeight: maxHeight * .5,
                  titleFontSize: 24,
                  descriptionFontSize: 14,
                ),
                Visibility(
                  visible: index == _onBoardingItems.length - 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      right: 30,
                      left: 30,
                    ),
                    child: CustomBtn(
                      label: AppText.next,
                      onPressed: () =>
                          Routemaster.of(context).replace('/login-mobile'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        OnBoardingTracker(
          currentIndex: _currentIndex,
          radius: 6,
        ),
        const Gap(30),
      ],
    );
  }
}

/// The widget to display on large screen for the login screen
class LoginLargeView extends StatefulWidget {
  /// Creates a [LoginLargeView] widget
  const LoginLargeView({super.key});

  @override
  State<LoginLargeView> createState() => _LoginLargeViewState();
}

class _LoginLargeViewState extends State<LoginLargeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: PageView.builder(
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _onBoardingItems.length,
            itemBuilder: (BuildContext context, int index) => _OnBoardingView(
              width: MediaQuery.sizeOf(context).width * .3,
              item: _onBoardingItems[index],
            ),
          ),
        ),
        Center(
          child: OnBoardingTracker(
            currentIndex: _currentIndex,
          ),
        ),
        const Gap(30),
      ],
    );
  }
}

/// The widget to track the slider item between the value of _OnboardingItems
class OnBoardingTracker extends StatelessWidget {
  /// Creates a [OnBoardingTracker] widget
  const OnBoardingTracker({
    required this.currentIndex,
    this.radius = 7,
    super.key,
  });

  /// The radius of the circle
  final double radius;

  /// The current index of the slider
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _onBoardingItems
          .map(
            (OnBoardingItemModel elm) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: radius,
                backgroundColor: currentIndex == _onBoardingItems.indexOf(elm)
                    ? kBlueColorVariant
                    : kWhiteColor,
              ),
            ),
          )
          .toList(),
    );
  }
}
