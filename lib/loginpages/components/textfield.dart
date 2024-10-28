import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Inputfield extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final FormFieldValidator? validator;

  const Inputfield({super.key, required this.hinttext, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          hintText: hinttext,
          labelText : hinttext,
          labelStyle: TextStyle(
            color: Colors.blue
          ),
          enabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey
            )
          ),
          focusedBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
      color: Colors.blue
      ),
        ),
        )
      ),
    );
  }
}
