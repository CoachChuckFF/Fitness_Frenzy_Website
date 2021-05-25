import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AST extends StatelessWidget {
  final String text;
  final int maxLines;
  final Color color;
  final bool isBold;
  final double size;
  final double minSize;
  final double height;
  final TextAlign textAlign;

  const AST(
    this.text,
    {
      this.maxLines = 1,
      this.color = Colors.black,
      this.isBold = false,
      this.size = 18,
      this.minSize = 8,
      this.height,
      this.textAlign = TextAlign.left,
      Key key
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.clip,
      wrapWords: false,
      minFontSize: minSize,
      style: TextStyle(
        height: height,
        color: color,
        fontWeight: (isBold) ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
      ),
    );
  }
}