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
      style: GoogleFonts.pressStart2p(  // 使用像素风格字体
        fontSize: fontSize,
        color: textColor,
        shadows: [
          Shadow(
            color: textColor.withOpacity(0.5),
            offset: const Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
    );
  }
} 