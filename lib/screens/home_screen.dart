import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/marquee_provider.dart';
import '../widgets/marquee_preview.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../widgets/font_size_dialog.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/speed_control_dialog.dart';
import '../widgets/led_style_dialog.dart';
import 'display_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marqueeState = ref.watch(marqueeProvider);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('跑马灯设置'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 输入框
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Focus(
                    child: TextFormField(
                      autofocus: false,
                      initialValue: marqueeState.text,
                      decoration: const InputDecoration(
                        labelText: '输入文字',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        ref.read(marqueeProvider.notifier).setText(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // 字体样式选择
                Row(
                  children: [
                    const Text('字体样式：'),
                    const SizedBox(width: 10),
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
                  ],
                ),
                const SizedBox(height: 20),

                // 控制按钮组
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _showColorPicker(context, ref);
                      },
                      child: const Text('选择颜色'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _showFontSizeDialog(context, ref);
                      },
                      child: const Text('调整字体大小'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _showSpeedDialog(context, ref);
                      },
                      child: const Text('调整滚动速度'),
                    ),
                    if (marqueeState.fontStyle == 'led')
                      ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _showLedStyleDialog(context, ref);
                        },
                        child: const Text('LED样式设置'),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // 背景设置按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _showBackgroundColorPicker(context, ref);
                      },
                      child: const Text('设置背景颜色'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _pickBackgroundImage(context, ref);
                      },
                      child: const Text('选择背景图片'),
                    ),
                    if (ref.watch(marqueeProvider).backgroundImage != null) ...[
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          ref.read(marqueeProvider.notifier).setBackgroundImage(null);
                        },
                        child: const Text('删除背景图片'),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 40),

                // 完成按钮
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // 移除焦点并收起键盘
                    FocusScope.of(context).unfocus();
                    
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DisplayScreen(),
                      ),
                    );
                  },
                  child: const Text('开始展示', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
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

  void _showLedStyleDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => LedStyleDialog(
        flashRate: ref.read(marqueeProvider).ledFlashRate,
        glowIntensity: ref.read(marqueeProvider).ledGlowIntensity,
        onStyleChanged: (flashRate, glowIntensity) {
          ref.read(marqueeProvider.notifier).setLedStyle(flashRate, glowIntensity);
        },
      ),
    );
  }
} 