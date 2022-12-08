import 'package:flutter/material.dart';

class textfeildinput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool ispass;
  final String hinttext;
  final TextInputType textInputType;

  const textfeildinput(
      {Key? key,
      required this.textEditingController,
      this.ispass = false,
      required this.hinttext,
      required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      autofocus: true,
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hinttext,
        border: InputBorder,
        focusedBorder: InputBorder,
        enabledBorder: InputBorder,
        filled: true,
        contentPadding: EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: ispass,
    );
  }
}
