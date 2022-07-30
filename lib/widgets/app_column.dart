import 'package:flutter/material.dart';
import 'package:food_delivery/widgets/small_text.dart';

import '../utils/colors.dart';
import 'big_text.dart';
import 'dimensions.dart';
import 'icon_and_text.dart';

class AppColumn extends StatelessWidget {
  AppColumn(this.bigText, {Key? key}) : super(key: key);

  String bigText = 'Chinese Side';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(bigText),
        SizedBox(
          height: Dimensions.pageViewTextContainerBoxSpace,
        ),
        Row(
          children: [
            Wrap(
              children: List.generate(
                  5,
                  (index) => Icon(
                        Icons.star,
                        size: Dimensions.width15,
                        color: AppColors.mainColor,
                      )),
            ),
            SizedBox(
              width: Dimensions.width10,
            ),
            SmallText('4.5'),
            SizedBox(
              width: Dimensions.width10,
            ),
            SmallText('1286'),
            SizedBox(
              width: Dimensions.width10,
            ),
            SmallText('comments'),
          ],
        ),
        SizedBox(
          height: Dimensions.pageViewTextContainerBoxSpace,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndTextWidget(
              icon: Icons.circle_sharp,
              iconColor: AppColors.iconColor1,
              text: 'Normal',
            ),
            IconAndTextWidget(
              icon: Icons.location_on,
              iconColor: AppColors.mainColor,
              text: '1.7km',
            ),
            IconAndTextWidget(
              icon: Icons.access_time_rounded,
              iconColor: AppColors.iconColor2,
              text: 'Normal',
            ),
          ],
        ),
      ],
    );
  }
}
