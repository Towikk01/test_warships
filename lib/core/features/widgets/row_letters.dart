import 'package:flutter/material.dart';

class RowLetters extends StatelessWidget {
  final double cellSize;
  const RowLetters({super.key, required this.cellSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: cellSize - 15,
          height: 20,
        ),
// Spacer for numbers column
        for (var i = 0; i < 10; i++)
          Container(
            width: cellSize - 5,
            height: 20,
            alignment: Alignment.center,
            child: Text(
              String.fromCharCode('A'.codeUnitAt(0) + i),
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
      ],
    );
  }
}
