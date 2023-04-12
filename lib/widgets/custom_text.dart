import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {Key? key, required this.text, this.color = Colors.white, this.fontSize})
      : super(key: key);

  final String text;
  final Color color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: fontSize ?? 10,
          ),
        ),
      ],
    );
  }
}

class CustomTitleText extends StatelessWidget {
  const CustomTitleText({
    Key? key,
    required this.title,
    this.color = Colors.white,
  }) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
