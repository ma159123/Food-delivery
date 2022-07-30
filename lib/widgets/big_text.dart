import 'package:flutter/cupertino.dart';

import 'dimensions.dart';
class BigText extends StatelessWidget {
  String text;
  Color color;
  double size;
  TextOverflow overflow;
  FontWeight fontWeight;

   BigText(this.text,{Key? key, this.overflow=TextOverflow.ellipsis,this.color=const Color(0xFF332d2b),this.size=0,this.fontWeight=FontWeight.bold,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        color: color,
        fontSize: size==0?Dimensions.bigText:size,
        fontWeight: fontWeight,
      ),
    );
  }
}
