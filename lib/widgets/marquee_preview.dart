import 'package:flutter/material.dart';
import 'dart:io';
import 'led_text.dart';
import 'pixel_text.dart';
import 'cartoon_text.dart';
import 'three_d_text.dart';

class MarqueePreview extends StatefulWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final double speed;
  final Color backgroundColor;
  final String? backgroundImage;
  final String fontStyle;
  final bool isPlaying;
  
  const MarqueePreview({
    super.key,
    required this.text,
    required this.textColor,
    required this.fontSize,
    required this.speed,
    required this.backgroundColor,
    required this.fontStyle,
    required this.isPlaying,
    this.backgroundImage,
  });

  @override
  State<MarqueePreview> createState() => _MarqueePreviewState();
}

class _MarqueePreviewState extends State<MarqueePreview> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final GlobalKey _textKey = GlobalKey();
  double _textWidth = 0;
  double _containerWidth = 0;

  void _startAnimation() {
    if (!widget.isPlaying) return;
    
    _controller
      ..forward();
  }

  void _updateAnimation() {
    final duration = Duration(milliseconds: (widget.speed * 1000).toInt().clamp(100, 30000));
    _controller.duration = duration;
    
    if (widget.isPlaying) {
      if (_controller.status == AnimationStatus.dismissed) {
        _controller.forward();
      } else {
        _controller.forward(from: _controller.value);
      }
    }
  }

  void _measureText() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_textKey.currentContext != null) {
        final RenderBox renderBox = _textKey.currentContext!.findRenderObject() as RenderBox;
        final containerBox = context.findRenderObject() as RenderBox;
        setState(() {
          _textWidth = renderBox.size.width;
          _containerWidth = containerBox.size.width;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: (widget.speed * 1000).toInt().clamp(100, 30000)),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.isPlaying && mounted) {
        _controller.forward(from: 0.0);
      }
    });

    _measureText();
    if (widget.isPlaying) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(MarqueePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    bool needsUpdate = oldWidget.text != widget.text || 
        oldWidget.textColor != widget.textColor ||
        oldWidget.fontSize != widget.fontSize ||
        oldWidget.speed != widget.speed ||
        oldWidget.isPlaying != widget.isPlaying ||
        oldWidget.backgroundImage != widget.backgroundImage ||
        oldWidget.backgroundColor != widget.backgroundColor;

    if (needsUpdate) {
      if (oldWidget.speed != widget.speed) {
        _updateAnimation();
      }
      
      if (oldWidget.isPlaying != widget.isPlaying) {
        if (widget.isPlaying) {
          _controller.forward();
        } else {
          _controller.stop();
        }
      }
      
      if (oldWidget.text != widget.text || oldWidget.fontSize != widget.fontSize) {
        if (widget.isPlaying) {
          _controller.forward(from: 0.0);
        }
      }
      
      _measureText();
    }
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
      case 'cartoon':
        textWidget = CartoonText(
          text: widget.text,
          fontSize: widget.fontSize,
          textColor: widget.textColor,
        );
        break;
      case '3d':
        textWidget = ThreeDText(
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
          maxLines: 1,
          overflow: TextOverflow.visible,
        );
        break;
      default:
        textWidget = Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.textColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.visible,
        );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        image: widget.backgroundImage?.isNotEmpty == true
            ? DecorationImage(
                image: FileImage(File(widget.backgroundImage!)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ClipRect(
              child: OverflowBox(
                maxWidth: double.infinity,
                alignment: Alignment.center,
                child: SlideTransition(
                  position: _animation,
                  child: Container(
                    key: _textKey,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: textWidget,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
} 