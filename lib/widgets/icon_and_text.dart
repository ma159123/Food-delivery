import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/widgets/small_text.dart';

class IconAndTextWidget extends StatelessWidget {
  IconData icon;
  Color iconColor;
  String text;
   IconAndTextWidget({Key? key,required this.text,required this.icon,required this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,color: iconColor,),
      SizedBox(width:5.0),
        SmallText(text,color:Colors.grey,),
      ],
    );
  }
}
