import 'package:flutter/material.dart';
import 'package:food_delivery/widgets/big_text.dart';

class NoDataPage extends StatelessWidget {
  String text;
  String imgPath;

  NoDataPage(
      {Key? key,
      required this.text,
      this.imgPath = 'assets/image/empty_cart.png'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            imgPath,
            width: MediaQuery.of(context).size.width * 0.22,
            height: MediaQuery.of(context).size.height * 0.22,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.03,),
          Text(
            text,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.0175,
              color: Theme.of(context).disabledColor,

            ),
           textAlign: TextAlign.center,

          ),
        ],
      ),
    );
  }
}
