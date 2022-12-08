

import 'package:flutter/material.dart';

class Followbutton extends StatelessWidget {
  final Function()? function;
  final Color backgroundcolor;
  final Color bordercolor;
  final String text;
  final Color textcolor;
  const Followbutton(
      {Key? key,
      required this.backgroundcolor,
      required this.bordercolor,
      required this.function,
      required this.text,
      required this.textcolor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundcolor,
            border: Border.all(color: bordercolor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
          ),
          width: 300,
          height: 27,
        ),
      ),
    );
  }
}
