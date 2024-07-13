import 'dart:ui';

import 'package:docs_ai/utils/functions.dart';

/// Represents the pricing model
class Pricing {
  /// Creates a [Pricing] model
  const Pricing({
    required this.id,
    required this.labelColor,
    required this.label,
    required this.price,
    required this.currency,
    required this.description,
    required this.advantages,
  });

  /// A function to convert a JSON to a Pricing instance
  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      id: json['_id'] as String,
      labelColor: stringToColor(json['labelColor'] as String),
      label: json['label'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      description: json['description'] as String,
      advantages: (json['advantages'] as List<dynamic>)
          .map<String>((dynamic e) => e as String)
          .toList(),
    );
  }

  /// The id of the pricing
  final String id;

  /// The color of the label
  final Color labelColor;

  /// The label of the pricing
  final String label;

  /// The price of the pricing
  final double price;

  /// The currency of the pricing
  final String currency;

  /// The description of the pricing
  final String description;

  /// The advantages of the pricing
  final List<String> advantages;
}
