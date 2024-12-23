import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpeedControlDialog extends StatefulWidget {
  final double initialSpeed;
  final ValueChanged<double> onSpeedChanged;

  const SpeedControlDialog({
    super.key,
    required this.initialSpeed,
    required this.onSpeedChanged,
  });

  @override
  State<SpeedControlDialog> createState() => _SpeedControlDialogState();
}

class _SpeedControlDialogState extends State<SpeedControlDialog> {
  late TextEditingController _controller;
  late double _speed;

  @override
  void initState() {
    super.initState();
    _speed = widget.initialSpeed;
    _controller = TextEditingController(text: _speed.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSpeed(double speed) {
    setState(() {
      _speed = speed;
      _controller.text = speed.toStringAsFixed(1);
    });
    widget.onSpeedChanged(speed);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('调整滚动速度'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    suffix: Text('秒'),
                    border: OutlineInputBorder(),
                    hintText: '输入滚动时间',
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      double? speed = double.tryParse(value);
                      if (speed != null && speed >= 0.1 && speed <= 30) {
                        _updateSpeed(speed);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Slider(
            value: _speed,
            min: 0.1,
            max: 30.0,
            divisions: 299,  // (30 - 0.1) * 10 为了支持小数点后一位
            label: '${_speed.toStringAsFixed(1)}秒',
            onChanged: _updateSpeed,
          ),
          const SizedBox(height: 20),
          const Text('滑动或输入调整滚动一次所需时间\n范围：0.1秒 - 30秒'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
} 