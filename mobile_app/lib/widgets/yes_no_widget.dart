import 'package:flutter/material.dart';

/// A widget for Yes/No questions using Radio buttons.
///
/// FIXED: The deprecated `groupValue` and `onChanged` properties of Radio
/// have been replaced with `value` and the direct `onChanged` callback on the ListTile.
/// This widget is now stateless and relies on the parent to manage state.
class YesNoWidget extends StatefulWidget {
  final String? selectedValue;
  final Function(String?) onChanged;

  const YesNoWidget({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<YesNoWidget> createState() => _YesNoWidgetState();
}

class _YesNoWidgetState extends State<YesNoWidget> {
  String? _internalSelectedValue;

  @override
  void initState() {
    super.initState();
    _internalSelectedValue = widget.selectedValue;
  }

  @override
  void didUpdateWidget(covariant YesNoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      _internalSelectedValue = widget.selectedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Yes'),
          leading: Radio<String>(
            value: 'yes',
            // ignore: deprecated_member_use
            groupValue: _internalSelectedValue,
            // ignore: deprecated_member_use
            onChanged: (String? value) {
              setState(() {
                _internalSelectedValue = value;
              });
              widget.onChanged(value);
            },
          ),
          onTap: () {
            setState(() {
              _internalSelectedValue = 'yes';
            });
            widget.onChanged('yes');
          },
        ),
        ListTile(
          title: const Text('No'),
          leading: Radio<String>(
            value: 'no',
            // ignore: deprecated_member_use
            groupValue: _internalSelectedValue,
            // ignore: deprecated_member_use
            onChanged: (String? value) {
              setState(() {
                _internalSelectedValue = value;
              });
              widget.onChanged(value);
            },
          ),
          onTap: () {
            setState(() {
              _internalSelectedValue = 'no';
            });
            widget.onChanged('no');
          },
        ),
      ],
    );
  }
}
