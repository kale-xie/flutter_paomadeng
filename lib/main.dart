import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paomadeng/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MarqueeApp(),
    ),
  );
}

class MarqueeApp extends StatelessWidget {
  const MarqueeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '跑马灯',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
