import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/marquee_provider.dart';
import '../widgets/marquee_preview.dart';

class DisplayScreen extends ConsumerStatefulWidget {
  const DisplayScreen({super.key});

  @override
  ConsumerState<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends ConsumerState<DisplayScreen> {
  bool _showControls = false;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _handleReturn(BuildContext context) {
    // 先关闭键盘
    FocusManager.instance.primaryFocus?.unfocus();
    // 然后返回
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final marqueeState = ref.watch(marqueeProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // 跑马灯内容
            MarqueePreview(
              text: marqueeState.text,
              textColor: marqueeState.textColor,
              fontSize: marqueeState.fontSize,
              speed: marqueeState.speed,
              backgroundColor: marqueeState.backgroundColor,
              backgroundImage: marqueeState.backgroundImage,
              fontStyle: marqueeState.fontStyle,
              isPlaying: _isPlaying,
            ),
            
            // 控制按钮
            if (_showControls)
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 返回按钮
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        iconSize: 36,
                        color: Colors.white,
                        onPressed: () => _handleReturn(context),
                      ),
                      const SizedBox(width: 20),
                      // 播放/暂停按钮
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                        iconSize: 48,
                        color: Colors.white,
                        onPressed: _togglePlayPause,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 