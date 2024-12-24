import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LedText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color textColor;

  const LedText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.textColor,
  });

  @override
  State<LedText> createState() => _LedTextState();
}

class _LedTextState extends State<LedText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    // 闪烁动画
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.4, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    // 颜色渐变动画
    _colorAnimation = ColorTween(
      begin: widget.textColor,
      end: widget.textColor.withOpacity(0.6),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // 外发光效果
            Text(
              widget.text,
              style: GoogleFonts.orbitron(
                fontSize: widget.fontSize,
                color: Colors.transparent,
                shadows: [
                  // 主要发光
                  Shadow(
                    color: widget.textColor.withOpacity(_opacityAnimation.value * 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                  // 扩散发光
                  Shadow(
                    color: widget.textColor.withOpacity(_opacityAnimation.value * 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 0),
                  ),
                  // 强烈中心光
                  Shadow(
                    color: widget.textColor.withOpacity(_opacityAnimation.value * 0.8),
                    blurRadius: 5,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
            // LED 主体效果
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.textColor.withOpacity(_opacityAnimation.value),
                    _colorAnimation.value ?? widget.textColor,
                    widget.textColor.withOpacity(_opacityAnimation.value * 0.8),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(bounds);
              },
              child: Text(
                widget.text,
                style: GoogleFonts.orbitron(
                  fontSize: widget.fontSize,
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
            // 高光效果
            Text(
              widget.text,
              style: GoogleFonts.orbitron(
                fontSize: widget.fontSize,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 0.5
                  ..color = Colors.white.withOpacity(_opacityAnimation.value * 0.3),
                letterSpacing: 2.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ],
        );
      },
    );
  }
} 