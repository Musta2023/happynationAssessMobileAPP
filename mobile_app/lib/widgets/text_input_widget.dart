import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  final Function(String) onChanged;
  final String? initialValue;

  const TextInputWidget({super.key, required this.onChanged, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: const InputDecoration(
        hintText: 'Your answer here...',
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
      maxLines: 3,
    );
  }
}
