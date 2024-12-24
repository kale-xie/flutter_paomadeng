import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartoonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;

  const CartoonText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 文字阴影效果
        Positioned(
          left: 2,
          top: 2,
          child: Text(
            text,
            style: GoogleFonts.longCang(  // 使用 Long Cang 字体
              fontSize: fontSize,
              color: Colors.black.withOpacity(0.25),
              height: 1.0,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.visible,
          ),
        ),
        // 描边效果
        Text(
          text,
          style: GoogleFonts.longCang(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = Colors.black.withOpacity(0.35),
            height: 1.0,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.visible,
        ),
        // 主文字
        Text(
          text,
          style: GoogleFonts.longCang(
            fontSize: fontSize,
            color: textColor,
            height: 1.0,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                offset: const Offset(0.5, 0.5),
                blurRadius: 1,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }
} 