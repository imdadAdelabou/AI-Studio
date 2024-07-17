import 'package:docs_ai/screens/document/studio/model/ai_model.dart';

/// Contains the features of the AI Studio
class FeatureDisplay {
  /// Creates a [FeatureDisplay]
  FeatureDisplay({
    required this.title,
    required this.icon,
    required this.models,
  });

  /// Contains the title of the feature
  final String title;

  /// Contains the icon of the feature
  final String icon;

  /// Contains the models of the feature
  final List<AiModel> models;
}
