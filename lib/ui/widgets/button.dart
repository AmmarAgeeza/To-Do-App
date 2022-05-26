import 'package:flutter/material.dart';
import 'package:todo/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.title, required this.onTap})
      : super(key: key);
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 30,
        decoration: BoxDecoration(
          color: primaryClr,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),

    );
  }
}
