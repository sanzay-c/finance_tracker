import 'package:flutter/material.dart';

class ColorModel {
  final Color lightModeColor;
  final Color darkModeColor;

  // Normal constructor
  ColorModel({
    required this.lightModeColor,
    required this.darkModeColor,
  });

  // Factory constructor for creating a ColorModel from a Map (deserialization)
  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      lightModeColor: Color(json['lightModeColor'] ?? 0xFFFFFFFF), // Default to white if not found
      darkModeColor: Color(json['darkModeColor'] ?? 0xFF000000), // Default to black if not found
    );
  }

  // Method to convert ColorModel to a Map (serialization)
  Map<String, dynamic> toJson() {
    return {
      'lightModeColor': lightModeColor.toARGB32(),
      'darkModeColor': darkModeColor.toARGB32(),
    };
  }

  // CopyWith method to create a copy of the current instance with modified fields
  ColorModel copyWith({
    Color? lightModeColor,
    Color? darkModeColor,
  }) {
    return ColorModel(
      lightModeColor: lightModeColor ?? this.lightModeColor,
      darkModeColor: darkModeColor ?? this.darkModeColor,
    );
  }
}
