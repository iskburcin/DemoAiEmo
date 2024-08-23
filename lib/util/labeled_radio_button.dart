import 'package:flutter/material.dart';

final List<String> genderList = ['Erkek', 'Kadın'];

class LabeledRadio extends StatefulWidget {
  const LabeledRadio({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.controller,
  });

  final String groupValue;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  @override
  _LabeledRadioState createState() => _LabeledRadioState();
}

class _LabeledRadioState extends State<LabeledRadio> {
  String gender = "";

  @override
  void initState() {
    super.initState();
    gender = widget.groupValue;
    widget.controller.text = gender;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, 
      children: [
      for (String genderOption in genderList)
        Row(
          children: [
            Radio<String>(
              value: genderOption,
              groupValue: gender,
              onChanged: (String? value) {
                setState(() {
                  gender = value!;
                  widget.onChanged(value);
                  widget.controller.text = value;
                });
              },
            ),
            Text(genderOption),
          ],
        ),
    ]);
  }
  }
