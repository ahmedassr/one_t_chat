import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style/color.dart';
import 'Components.dart';

class CustomProfileContainer extends StatelessWidget{
  final String title;
  final String num;
  CustomProfileContainer(this.title, this.num, {super.key});
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 95,
      height: 70,
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          colors: [Colors.blue.withOpacity(0.5), Colors.blueGrey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
            12), // Match card's corner radius
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            CustomBoldText(
                title: title,
                size: 18,
                fontWeight: FontWeight.bold,
                background: primaryColor),

            CustomBoldText(
                title: num,
                size: 20,
                background: primaryColor)
          ],
        ),
      ),
    );
  }

}