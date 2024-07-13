import 'package:docs_ai/screens/document/studio/feature_card.dart';
import 'package:docs_ai/screens/document/studio/model/feature_display.dart';
import 'package:docs_ai/utils/app_assets.dart';
import 'package:flutter/material.dart';

final List<FeatureDisplay> _features = <FeatureDisplay>[
  FeatureDisplay(
    title: 'Summarize',
    icon: AppAssets.summarizeTextIcon,
  ),
  FeatureDisplay(
    title: 'Generate Image',
    icon: AppAssets.generateImageIcon,
  ),
  FeatureDisplay(
    title: 'Ask AI',
    icon: AppAssets.askAIIcon,
  ),
];

/// Contains the visual aspect of the AI Studio
class AiStudio extends StatelessWidget {
  /// Creates a [AiStudio]
  const AiStudio({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _features
              .map<Widget>(
                (FeatureDisplay feature) => Padding(
                  padding: const EdgeInsets.only(
                    right: 18,
                  ),
                  child: FeatureCard(
                    icon: feature.icon,
                    title: feature.title,
                    width: 150,
                    height: 150,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
