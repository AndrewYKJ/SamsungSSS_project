import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.context,
      required this.color,
      required this.function,
      required this.text,
      required this.font})
      : super(key: key);

  final BuildContext context;
  final Color color;
  final dynamic function;
  final String text;
  final TextStyle font;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(8), color: color),
        child: Center(
          child: Text(text, style: font),
        ),
      ),
    );
  }
}
