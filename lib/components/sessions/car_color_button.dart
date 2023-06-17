import 'package:distributed_computing_project/classes/colors.dart';
import 'package:flutter/material.dart';

class CarColorButton extends StatefulWidget {
  Color color;
  String value;
  CarColorButton({Key? key, required this.color, required this.value}) : super(key: key);

  @override
  State<CarColorButton> createState() => _CarColorButtonState(color, value);
}

class _CarColorButtonState extends State<CarColorButton> {
  Color color;
  String value;

  _CarColorButtonState(this.color, this.value);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 10,
        backgroundColor: AppColors.highlight,
        child: CircleAvatar(
          radius: 8,
          backgroundColor: color,
        )
    );
  }
}
