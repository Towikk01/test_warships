import 'package:flutter/material.dart';

class ColumnNumbers extends StatelessWidget {
  final double cellSize;
  const ColumnNumbers({super.key, required this.cellSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 10; i++)
          Container(
            width: 20,
            height: cellSize - 0.6,
            alignment: Alignment.center,
            child: Text(
              (i + 1).toString(),
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
      ],
    );
  }
}
