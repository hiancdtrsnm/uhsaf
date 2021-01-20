import 'package:flutter/material.dart';

class SAFDropdownField extends StatelessWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;

  const SAFDropdownField({
    Key key,
    @required this.label,
    @required this.options,
    @required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      items: [
        for (var option in options)
          DropdownMenuItem(
            child: Center(
              child: Text(option),
            ),
            value: option,
          ),
      ],
      onChanged: onChanged,
      validator: validator,
    );
  }
}
