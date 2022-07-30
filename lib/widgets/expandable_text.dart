import 'package:flutter/material.dart';
import 'package:food_delivery/widgets/small_text.dart';

import '../utils/colors.dart';
import 'dimensions.dart';

class ExpandableText extends StatefulWidget {
  String text;
  ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String secondHalf;
  late String firstHalf;
  bool hiddenText = true;
  double textHeight = Dimensions.screenHeight / 7.63;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? SmallText(firstHalf,height: 1.8,
        size: Dimensions.font16,
        color: AppColors.paraColor,)
          : Column(
              children: [
                SmallText(
                  hiddenText ? (firstHalf + "...") : (firstHalf + secondHalf),
                  height: 1.8,
                  size: Dimensions.font16,
                  color: AppColors.paraColor,
                ),
                InkWell(
                  onTap: () {
                    setState(() {

                      hiddenText= !hiddenText;
                      print(hiddenText);
                    });
                  },
                  child: Row(
                    children: [
                      SmallText(
                        "Show more",
                        color: AppColors.mainColor,
                      ),
                      Icon(
                       hiddenText? Icons.arrow_drop_down:Icons.arrow_drop_up,
                        color: AppColors.mainColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
