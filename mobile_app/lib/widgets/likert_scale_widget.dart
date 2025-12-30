import 'package:flutter/material.dart';

class LikertScaleWidget extends StatelessWidget {
  final int? selectedValue;
  final ValueChanged<int> onChanged;

  const LikertScaleWidget({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Default to a middle value if null, but it should ideally not be null
    // if a question is presented.
    final currentValue = selectedValue ?? 3;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Slider(
            value: currentValue.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: currentValue.toString(),
            onChanged: (double value) {
              onChanged(value.toInt());
            },
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Strongly Disagree'),
            Text('Strongly Agree'),
          ],
        )
      ],
    );
  }
}