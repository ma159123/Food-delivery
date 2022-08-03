import 'package:flutter/material.dart';
import 'package:food_delivery/home/cart.dart';
import 'package:food_delivery/home/history.dart';
import 'package:food_delivery/home/main_food_page.dart';
import 'package:food_delivery/home/me.dart';
import 'package:food_delivery/utils/colors.dart';

import 'order_page.dart';
import 'order_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index=0;
  @override
  Widget build(BuildContext context) {

    List<Widget>pages=[
      const MainFoodPage(),
      const OrderScreen(),
      const HistoryPage(),
      const AccountPage(),
    ];

    void changeIndex(int i){
      setState(() {
        index=i;
        print(index);
      });

    }
    return Scaffold(
      body:pages[index] ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: Colors.amberAccent,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: changeIndex,
        items: const [
        BottomNavigationBarItem(icon:Icon( Icons.home_outlined),label: 'Home'),
        BottomNavigationBarItem(icon:Icon( Icons.archive_outlined),label: 'History'),
        BottomNavigationBarItem(icon:Icon( Icons.shopping_cart),label: 'Cart'),
        BottomNavigationBarItem(icon:Icon( Icons.person),label: 'Me'),
      ],

      ),
    );
  }
}
