import 'package:distributed_computing_project/classes/colors.dart';
import 'package:flutter/material.dart';

class CounterButtonController {
  int count = 0;
}

// ignore: must_be_immutable
class CounterButton extends StatefulWidget {
  CounterButtonController controller;
  int counter = 1;
  final String buttonName;
  final int minimum;
  final int maximum;

  CounterButton({Key? key, required this.controller, required this.buttonName, required this.minimum, required this.maximum}) : super(key: key);

  @override
  State<CounterButton> createState() => _CounterButtonState();

  void increment() {
    if (counter == maximum) {
      return;
    }
    counter++;
    controller.count = counter;
  }

  void decrement() {
    if (counter == minimum) {
      return;
    }
    counter--;
    controller.count = counter;
  }
}

class _CounterButtonState extends State<CounterButton> {
  bool _incrementIsHovered = false;
  bool _decrementIsHovered = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.buttonName,
          style: const TextStyle(
            color: AppColors.highlight
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.highlight,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => setState(() {
                  widget.decrement();
                }),
                onHover: (hovering) {
                  setState(() {
                    _decrementIsHovered = hovering;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  decoration: BoxDecoration(
                    color: _decrementIsHovered  ? AppColors.accentLighter : AppColors.highlight,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: const Icon(Icons.remove)
                ),
              ),
              Text('${widget.counter}'),
              InkWell(
                onTap: () {
                  setState(() {
                    widget.increment();
                  });
                },
                onHover: (hovering) {
                  setState(() {
                    _incrementIsHovered = hovering;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  decoration: BoxDecoration(
                    color: _incrementIsHovered ? AppColors.accentLighter : AppColors.highlight,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: const Icon(Icons.add)
                ),
              )
            ],
          )
        ),
      ],
    );
  }
}

