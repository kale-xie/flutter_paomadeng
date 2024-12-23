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

  const MarqueeState({
    this.text = '',
    this.fontStyle = 'normal',
    this.textColor = Colors.black,
    this.fontSize = 24,
    this.speed = 10,
    this.backgroundColor = Colors.white,
    this.backgroundImage,
  });

  MarqueeState copyWith({
    String? text,
    String? fontStyle,
    Color? textColor,
    double? fontSize,
    double? speed,
    Color? backgroundColor,
    String? backgroundImage,
  }) {
    return MarqueeState(
      text: text ?? this.text,
      fontStyle: fontStyle ?? this.fontStyle,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      speed: speed ?? this.speed,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundImage: backgroundImage ?? this.backgroundImage,
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
    if (path == null) {
      state = state.copyWith(
        backgroundImage: null,
        backgroundColor: state.backgroundColor,
      );
    } else {
      state = state.copyWith(
        backgroundImage: path,
        backgroundColor: Colors.transparent,
      );
    }
  }
} 