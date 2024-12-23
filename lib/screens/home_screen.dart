import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/marquee_provider.dart';
import '../widgets/marquee_preview.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../widgets/font_size_dialog.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/speed_control_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marqueeState = ref.watch(marqueeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('跑马灯设置'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '输入显示文字',
              ),
              onChanged: (value) => ref.read(marqueeProvider.notifier).setText(value),
            ),
          ),
          const SizedBox(height: 20),
          // 字体样式选择
          DropdownButton<String>(
            value: marqueeState.fontStyle,
            items: const [
              DropdownMenuItem(value: 'led', child: Text('LED样式')),
              DropdownMenuItem(value: 'neon', child: Text('霓虹样式')),
              DropdownMenuItem(value: 'pixel', child: Text('像素字体')),
              DropdownMenuItem(value: 'normal', child: Text('普通样式')),
            ],
            onChanged: (value) => ref.read(marqueeProvider.notifier).setFontStyle(value!),
          ),
          // 颜色选择器
          ElevatedButton(
            onPressed: () => _showColorPicker(context, ref),
            child: const Text('选择颜色'),
          ),
          // 大小调节滑块
          ElevatedButton(
            onPressed: () => _showFontSizeDialog(context, ref),
            child: const Text('调整字体大小'),
          ),
          // 速度控制按钮
          ElevatedButton(
            onPressed: () => _showSpeedDialog(context, ref),
            child: const Text('调整滚动速度'),
          ),
          // 添加背景设置按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _showBackgroundColorPicker(context, ref),
                child: const Text('设置背景颜色'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _pickBackgroundImage(context, ref),
                child: const Text('选择背景图片'),
              ),
              // 添加清除背景图片按钮，只在有背景图片时显示
              if (ref.watch(marqueeProvider).backgroundImage != null) ...[
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    ref.read(marqueeProvider.notifier).setBackgroundImage(null);
                  },
                  child: const Text('清除背景图片'),
                ),
              ],
            ],
          ),
          // 预览区域
          Expanded(
            child: MarqueePreview(
              text: marqueeState.text,
              textColor: marqueeState.textColor,
              fontSize: marqueeState.fontSize,
              speed: marqueeState.speed,
              backgroundColor: marqueeState.backgroundColor,
              backgroundImage: marqueeState.backgroundImage,
              fontStyle: marqueeState.fontStyle,
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择颜色'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: ref.read(marqueeProvider).textColor,
            onColorChanged: (color) {
              ref.read(marqueeProvider.notifier).setTextColor(color);
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => FontSizeDialog(
        initialSize: ref.read(marqueeProvider).fontSize,
        onSizeChanged: (size) {
          ref.read(marqueeProvider.notifier).setFontSize(size);
        },
      ),
    );
  }

  void _showSpeedDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SpeedControlDialog(
        initialSpeed: ref.read(marqueeProvider).speed,
        onSpeedChanged: (speed) {
          ref.read(marqueeProvider.notifier).setSpeed(speed);
        },
      ),
    );
  }

  void _showBackgroundColorPicker(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择背景颜色'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: ref.read(marqueeProvider).backgroundColor,
            onColorChanged: (color) {
              ref.read(marqueeProvider.notifier).setBackgroundColor(color);
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickBackgroundImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      ref.read(marqueeProvider.notifier).setBackgroundImage(pickedFile.path);
    }
  }
} 