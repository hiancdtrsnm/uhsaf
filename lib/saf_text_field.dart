import 'package:flutter/material.dart';

class SAFTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final int minLines;
  final int maxLines;

  const SAFTextField({
    Key key,
    @required this.label,
    @required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.minLines,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      controller: controller,
      validator: validator,
    );
  }
}