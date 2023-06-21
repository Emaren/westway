import 'package:flutter/material.dart';
import 'package:outlined_text/models/outlined_text_stroke.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color fillColor;
  final Color outlineColor;
  final double strokeWidth;

  const OutlinedText({super.key, 
    required this.text,
    this.fontSize = 24,
    this.fillColor = Colors.white,
    this.outlineColor = Colors.red,
    this.strokeWidth = 2.0,
    required List<OutlinedTextStroke> strokes,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // Stroked text
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..color = outlineColor,
            ),
          ),
          // Solid text
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: fillColor,
            ),
          ),
        ],
      ),
    );
  }
}
