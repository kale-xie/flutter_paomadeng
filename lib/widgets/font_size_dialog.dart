import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FontSizeDialog extends StatefulWidget {
  final double initialSize;
  final ValueChanged<double> onSizeChanged;

  const FontSizeDialog({
    super.key,
    required this.initialSize,
    required this.onSizeChanged,
  });

  @override
  State<FontSizeDialog> createState() => _FontSizeDialogState();
}

class _FontSizeDialogState extends State<FontSizeDialog> {
  late TextEditingController _controller;
  late double _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialSize;
    _controller = TextEditingController(text: _fontSize.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateFontSize(double size) {
    setState(() {
      _fontSize = size;
      _controller.text = size.toStringAsFixed(0);
    });
    widget.onSizeChanged(size);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('调整字体大小'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    suffix: Text('px'),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      double size = double.parse(value);
                      if (size >= 12 && size <= 200) {
                        _updateFontSize(size);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Slider(
            value: _fontSize,
            min: 12,
            max: 200,
            divisions: 60,
            label: _fontSize.toStringAsFixed(0),
            onChanged: _updateFontSize,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '字',
              style: TextStyle(fontSize: _fontSize),
            ),
          ),
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