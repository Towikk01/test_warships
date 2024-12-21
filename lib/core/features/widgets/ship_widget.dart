import 'package:flutter/material.dart';
import 'package:test_warships/core/models/ship.dart';

class ShipWidget extends StatelessWidget {
  final Ship ship;

  const ShipWidget({Key? key, required this.ship}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ship.isHorizontal ? 30.0 * ship.size : ship.size * 30.0,
      color: Colors.transparent,
      child: Center(
        child: Transform.rotate(
          angle: !ship.isHorizontal
              ? 0
              : 3.14159 / 2, // Rotate 90 degrees if vertical
          child: Image.asset(
            'assets/ship-${ship.size}.png',
            fit: BoxFit.cover, // Makes the image fill the container
          ),
        ),
      ),
    );
  }
}
