import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final int initialSeconds;

  CustomTimePicker({required this.initialTime, required this.initialSeconds});

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int _hour;
  late int _minute;
  late int _second;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialTime.hour;
    _minute = widget.initialTime.minute;
    _second = widget.initialSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: NumberPicker(
                  minValue: 0,
                  maxValue: 23,
                  value: _hour,
                  onChanged: (value) {
                    setState(() {
                      _hour = value!;
                    });
                  },
                ),
              ),
              Text(':'),
              Expanded(
                child: NumberPicker(
                  minValue: 0,
                  maxValue: 59,
                  value: _minute,
                  onChanged: (value) {
                    setState(() {
                      _minute = value!;
                    });
                  },
                ),
              ),
              Text(':'),
              Expanded(
                child: NumberPicker(
                  minValue: 0,
                  maxValue: 59,
                  value: _second,
                  onChanged: (value) {
                    setState(() {
                      _second = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop({
              'hour': _hour,
              'minute': _minute,
              'second': _second,
            });
          },
        ),
      ],
    );
  }
}

class NumberPicker extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int value;
  final ValueChanged<int?> onChanged;

  NumberPicker({
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: value,
      items: List.generate(
        maxValue - minValue + 1,
            (index) => DropdownMenuItem(
          value: minValue + index,
          child: Text('${minValue + index}'),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
