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
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
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
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            // LED 发光文字
            Text(
              widget.text,
              style: GoogleFonts.orbitron(  // 使用 Google Fonts 的 Orbitron 字体
                fontSize: widget.fontSize,
                color: widget.textColor.withOpacity(_animation.value),
                shadows: [
                  // 内发光
                  Shadow(
                    color: widget.textColor.withOpacity(_animation.value * 0.8),
                    blurRadius: 0,
                    offset: const Offset(0, 0),
                  ),
                  // 外发光 1
                  Shadow(
                    color: widget.textColor.withOpacity(_animation.value * 0.5),
                    blurRadius: 15,
                  ),
                  // 外发光 2
                  Shadow(
                    color: widget.textColor.withOpacity(_animation.value * 0.3),
                    blurRadius: 25,
                  ),
                ],
              ),
            ),
            // LED 点阵效果
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    widget.textColor.withOpacity(_animation.value),
                    widget.textColor.withOpacity(_animation.value * 0.8),
                  ],
                  stops: const [0.0, 1.0],
                ).createShader(bounds);
              },
              child: Text(
                widget.text,
                style: GoogleFonts.orbitron(  // 这里也使用 Orbitron 字体
                  fontSize: widget.fontSize,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
} 