import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_warships/core/features/widgets/ship_widget.dart';
import 'package:test_warships/core/models/ship.dart';
import 'package:test_warships/core/viewmodels/game_viewmodel.dart';

class ListShips extends ConsumerWidget {
  const ListShips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(gameStateProvider);
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: viewModel.ships.where((ship) => !ship.isPlaced).map((ship) {
          return Draggable<Ship>(
            data: ship,
            feedback: Material(
              color: Colors.transparent,
              child: ShipWidget(ship: ship),
            ),
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: ShipWidget(ship: ship),
            ),
            child: ShipWidget(ship: ship),
          );
        }).toList(),
      ),
    );
  }
}
