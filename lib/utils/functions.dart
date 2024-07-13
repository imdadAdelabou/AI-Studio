import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Formats the date in the format 'yyyy/MM/dd'.
String formatDate(DateTime createdAt) {
  return DateFormat('yyyy/MM/dd').format(createdAt);
}

/// Converts a string to a color object.
Color stringToColor(String colorString) {
  // Define a map of color names to Color objects
  final Map<String, Color> colorMap = <String, Color>{
    'red': Colors.red,
    'green': Colors.green,
    // Add more colors as needed
  };

  // Try to find the corresponding Color object for the given colorString
  Color? color = colorMap[colorString.toLowerCase()];

  // If color is null (not found), return a default color (you can change it as needed)
  color ??= Colors.black;

  return color;
}
