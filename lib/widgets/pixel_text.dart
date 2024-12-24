import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PixelText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;

  const PixelText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.dotGothic16(
        fontSize: fontSize,
        color: textColor,
        height: 1.0,
      ),
      maxLines: 1,
      overflow: TextOverflow.visible,
    );
  }
} 