import 'package:flutter/material.dart';
import 'dart:io';
import 'led_text.dart';
import 'pixel_text.dart';

class MarqueePreview extends StatefulWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final double speed;
  final Color backgroundColor;
  final String? backgroundImage;
  final String fontStyle;
  
  const MarqueePreview({
    super.key,
    required this.text,
    required this.textColor,
    required this.fontSize,
    required this.speed,
    required this.backgroundColor,
    this.backgroundImage,
    required this.fontStyle,
  });

  @override
  State<MarqueePreview> createState() => _MarqueePreviewState();
}

class _MarqueePreviewState extends State<MarqueePreview> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  void _updateAnimation() {
    final duration = Duration(milliseconds: (widget.speed * 1000).toInt().clamp(100, 30000));
    _controller.duration = duration;
    _controller
      ..reset()
      ..repeat();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: (widget.speed * 1000).toInt().clamp(100, 30000)),
      vsync: this,
    )..repeat();

    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(MarqueePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || 
        oldWidget.textColor != widget.textColor ||
        oldWidget.fontSize != widget.fontSize ||
        oldWidget.speed != widget.speed) {
      if (oldWidget.speed != widget.speed) {
        _updateAnimation();
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget textWidget;
    
    switch (widget.fontStyle) {
      case 'led':
        textWidget = LedText(
          text: widget.text,
          fontSize: widget.fontSize,
          textColor: widget.textColor,
        );
        break;
      case 'pixel':
        textWidget = PixelText(
          text: widget.text,
          fontSize: widget.fontSize,
          textColor: widget.textColor,
        );
        break;
      case 'neon':
        textWidget = Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.textColor,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: widget.textColor.withOpacity(0.8),
                blurRadius: 12,
                offset: const Offset(0, 0),
              ),
              Shadow(
                color: Colors.white.withOpacity(0.8),
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        );
        break;
      default:
        textWidget = Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.textColor,
          ),
        );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: widget.backgroundImage == null ? widget.backgroundColor : Colors.transparent,
        image: widget.backgroundImage != null
            ? DecorationImage(
                image: FileImage(File(widget.backgroundImage!)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Center(
        child: SlideTransition(
          position: _animation,
          child: textWidget,
        ),
      ),
    );
  }
} 