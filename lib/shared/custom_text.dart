import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.overflow,
  }) : super(key: key);
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextOverflow? overflow;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        overflow: overflow,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color:
            color ??
            Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }
}
