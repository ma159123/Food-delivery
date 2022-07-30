import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/big_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final bool backButtonExist;
  final Function? onBackPressed;

  const CustomAppBar({Key? key,required this.title,required this.backButtonExist,required this.onBackPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.mainColor,
      elevation: 0,
      title: BigText(title,color:  Colors.white,),
      centerTitle: true,
      leading: backButtonExist?IconButton(onPressed:()=> onBackPressed!=null?onBackPressed!():Navigator.pushReplacementNamed(context, '/initial'),
          icon: Icon(Icons.arrow_back_ios)):Container()
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(500,53);
}
