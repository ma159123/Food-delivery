import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  String text;
  Color color;
  double size;
  FontWeight fontWeight=FontWeight.w400;
  double height;

  SmallText(this.text,{Key? key,this.size=12,this.height=1.2,this.fontWeight=FontWeight.bold,this.color=Colors.grey,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
