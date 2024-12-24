import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LedStyleDialog extends StatefulWidget {
  final double flashRate;  // 闪烁频率
  final double glowIntensity;  // 发光强度
  final Function(double, double) onStyleChanged;  // 回调函数

  const LedStyleDialog({
    super.key,
    required this.flashRate,
    required this.glowIntensity,
    required this.onStyleChanged,
  });

  @override
  State<LedStyleDialog> createState() => _LedStyleDialogState();
}

class _LedStyleDialogState extends State<LedStyleDialog> {
  late TextEditingController _flashRateController;
  late TextEditingController _glowController;
  late double _flashRate;
  late double _glowIntensity;

  @override
  void initState() {
    super.initState();
    _flashRate = widget.flashRate;
    _glowIntensity = widget.glowIntensity;
    _flashRateController = TextEditingController(text: _flashRate.toStringAsFixed(1));
    _glowController = TextEditingController(text: _glowIntensity.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _flashRateController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _updateStyle() {
    widget.onStyleChanged(_flashRate, _glowIntensity);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('LED样式设置'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 闪烁频率控制
          const Text('闪烁频率'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _flashRateController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    suffix: Text('秒'),
                    border: OutlineInputBorder(),
                    hintText: '闪烁间隔',
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      double? rate = double.tryParse(value);
                      if (rate != null && rate >= 0.1 && rate <= 3.0) {
                        setState(() {
                          _flashRate = rate;
                        });
                        _updateStyle();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          Slider(
            value: _flashRate,
            min: 0.1,
            max: 3.0,
            divisions: 29,
            label: '${_flashRate.toStringAsFixed(1)}秒',
            onChanged: (value) {
              setState(() {
                _flashRate = value;
                _flashRateController.text = value.toStringAsFixed(1);
              });
              _updateStyle();
            },
          ),
          const SizedBox(height: 20),
          // 发光强度控制
          const Text('发光强度'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _glowController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '发光强度',
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      double? intensity = double.tryParse(value);
                      if (intensity != null && intensity >= 0.1 && intensity <= 2.0) {
                        setState(() {
                          _glowIntensity = intensity;
                        });
                        _updateStyle();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          Slider(
            value: _glowIntensity,
            min: 0.1,
            max: 2.0,
            divisions: 19,
            label: _glowIntensity.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _glowIntensity = value;
                _glowController.text = value.toStringAsFixed(1);
              });
              _updateStyle();
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('确定'),
        ),
      ],
    );
  }
} 