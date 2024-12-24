import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThreeDText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;

  const ThreeDText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // 生成3D效果的层
    List<Widget> layers = [];
    
    // 计算主色调的HSL值，用于生成渐变色
    final HSLColor hsl = HSLColor.fromColor(textColor);
    
    // 减少层数，只保留关键的几层
    const int totalLayers = 8;  // 减少层数
    for (int i = totalLayers; i >= 1; i--) {
      // 计算每层的颜色
      final layerColor = hsl.withLightness(
        (hsl.lightness * 0.7 * i / totalLayers).clamp(0.0, 1.0)
      ).toColor();

      layers.add(
        Transform.translate(  // 使用 Transform.translate 替代 Positioned 以提高性能
          offset: Offset(i * 2.0, i * 2.0),
          child: Text(
            text,
            style: GoogleFonts.notoSansSc(
              fontSize: fontSize,
              color: layerColor.withOpacity(0.8),
              height: 1.0,
              fontWeight: FontWeight.w900,
            ),
            maxLines: 1,
            overflow: TextOverflow.visible,
          ),
        ),
      );
    }

    // 添加主要描边效果
    layers.add(
      Text(
        text,
        style: GoogleFonts.notoSansSc(
          fontSize: fontSize,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..color = Colors.black.withOpacity(0.8),
          height: 1.0,
          fontWeight: FontWeight.w900,
        ),
        maxLines: 1,
        overflow: TextOverflow.visible,
      ),
    );

    // 添加主文字
    layers.add(
      Text(
        text,
        style: GoogleFonts.notoSansSc(
          fontSize: fontSize,
          color: textColor,
          height: 1.0,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(
              offset: const Offset(2.0, 2.0),
              blurRadius: 0,
              color: Colors.black.withOpacity(0.6),
            ),
            Shadow(
              offset: const Offset(-1.0, -1.0),
              blurRadius: 0,
              color: Colors.white.withOpacity(0.4),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.visible,
      ),
    );

    // 添加高光效果
    layers.add(
      Transform.translate(
        offset: const Offset(-2.0, -2.0),
        child: Text(
          text,
          style: GoogleFonts.notoSansSc(
            fontSize: fontSize,
            color: Colors.white.withOpacity(0.3),
            height: 1.0,
            fontWeight: FontWeight.w900,
          ),
          maxLines: 1,
          overflow: TextOverflow.visible,
        ),
      ),
    );

    return RepaintBoundary(  // 添加 RepaintBoundary 以优化重绘性能
      child: Stack(
        children: layers,
      ),
    );
  }
} 