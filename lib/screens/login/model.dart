/// Represents the data model for the onboarding screen.
class OnBoardingItemModel {
  /// Creates a [OnBoardingItemModel] widget
  const OnBoardingItemModel({
    required this.title,
    required this.description,
    required this.icon,
  });

  /// The title of the onboarding screen
  final String title;

  /// The icon of the onboarding screen
  final String icon;

  /// The description of the onboarding screen
  final String description;
}
