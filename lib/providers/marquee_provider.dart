import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'marquee_provider.g.dart';

@immutable
class MarqueeState {
  final String text;
  final String fontStyle;
  final Color textColor;
  final double fontSize;
  final double speed;
  final Color backgroundColor;
  final String? backgroundImage;
  final double ledFlashRate;
  final double ledGlowIntensity;

  const MarqueeState({
    this.text = '',
    this.fontStyle = 'normal',
    this.textColor = Colors.black,
    this.fontSize = 24,
    this.speed = 10,
    this.backgroundColor = Colors.white,
    this.backgroundImage,
    this.ledFlashRate = 1.0,
    this.ledGlowIntensity = 1.0,
  });

  MarqueeState copyWith({
    String? text,
    String? fontStyle,
    Color? textColor,
    double? fontSize,
    double? speed,
    Color? backgroundColor,
    String? backgroundImage,
    double? ledFlashRate,
    double? ledGlowIntensity,
  }) {
    return MarqueeState(
      text: text ?? this.text,
      fontStyle: fontStyle ?? this.fontStyle,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      speed: speed ?? this.speed,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      ledFlashRate: ledFlashRate ?? this.ledFlashRate,
      ledGlowIntensity: ledGlowIntensity ?? this.ledGlowIntensity,
    );
  }
}

@riverpod
class Marquee extends _$Marquee {
  @override
  MarqueeState build() {
    return const MarqueeState();
  }

  void setText(String text) {
    state = state.copyWith(text: text);
  }

  void setFontStyle(String style) {
    state = state.copyWith(fontStyle: style);
  }

  void setTextColor(Color color) {
    state = state.copyWith(textColor: color);
  }

  void setFontSize(double size) {
    state = state.copyWith(fontSize: size);
  }

  void setSpeed(double speed) {
    state = state.copyWith(speed: speed);
  }

  void setBackgroundColor(Color color) {
    state = state.copyWith(
      backgroundColor: color,
    );
  }

  void setBackgroundImage(String? path) {
    state = MarqueeState(
      text: state.text,
      fontStyle: state.fontStyle,
      textColor: state.textColor,
      fontSize: state.fontSize,
      speed: state.speed,
      backgroundColor: state.backgroundColor,
      backgroundImage: path,
      ledFlashRate: state.ledFlashRate,
      ledGlowIntensity: state.ledGlowIntensity,
    );
  }

  void setLedStyle(double flashRate, double glowIntensity) {
    state = state.copyWith(
      ledFlashRate: flashRate,
      ledGlowIntensity: glowIntensity,
    );
  }
} 