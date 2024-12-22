import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_warships/core/features/widgets/ship_widget.dart';
import 'package:test_warships/core/models/ship.dart';
import 'package:test_warships/core/viewmodels/game_viewmodel.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(gameStateProvider);

    final viewModelNotifier = ref.read(gameStateProvider.notifier);
    return Expanded(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          childAspectRatio: 1.0,
        ),
        itemCount: 100,
        itemBuilder: (context, index) {
          final x = index ~/ 10;
          final y = index % 10;
          final shipOnCell = viewModel.findShipByPosition(x, y);
          final shipPart = shipOnCell != null
              ? shipOnCell.positions.indexOf(x * 10 + y) + 1
              : 0;

          return DragTarget<Ship>(
            onAcceptWithDetails: (ship) {
              viewModelNotifier.removeShip(ship.data);

              if (viewModelNotifier.canPlaceShip(
                  ship.data, x, y, ship.data.isHorizontal)) {
                viewModelNotifier.placeShip(
                    ship.data, x, y, ship.data.isHorizontal);
              }
            },
            builder: (context, candidateData, rejectedData) {
              final isOccupied = viewModel.board[x][y] != 0;
              final draggedShip =
                  candidateData.isNotEmpty ? candidateData.first : null;
              final isSameShip = draggedShip == shipOnCell;
              final isValidDrop = draggedShip != null &&
                  (isSameShip ||
                      viewModelNotifier.canPlaceShip(
                          draggedShip, x, y, draggedShip.isHorizontal));
              return GestureDetector(
                onLongPress: shipOnCell != null
                    ? () {
                        viewModelNotifier.rotateShip(shipOnCell);
                      }
                    : null,
                child: Draggable<Ship>(
                  data: shipOnCell,
                  onDraggableCanceled: (_, __) {
                    shipOnCell?.isHorizontal = false;
                    viewModelNotifier.removeShip(shipOnCell!);
                  },
                  feedback: Material(
                    color: Colors.transparent,
                    child: shipOnCell != null
                        ? ShipWidget(ship: shipOnCell)
                        : const SizedBox.shrink(),
                  ),
                  childWhenDragging: shipOnCell != null
                      ? Container(
                          color: Colors.green,
                          child: Transform.rotate(
                            angle:
                                !shipOnCell.isHorizontal ? 0 : -(3.14159 / 2),
                            child: Image.asset(
                                'assets/${shipOnCell.size}-$shipPart.png'),
                          ),
                        )
                      : Container(color: Colors.blueAccent),
                  child: Container(
                    margin: EdgeInsets.all(shipOnCell == null ? 1 : 0),
                    decoration: BoxDecoration(
                      color: isOccupied ? Colors.green : Colors.blueAccent,
                      border: isValidDrop
                          ? Border.all(color: Colors.green, width: 2)
                          : null,
                    ),
                    child: shipOnCell != null
                        ? Transform.rotate(
                            angle:
                                !shipOnCell.isHorizontal ? 0 : -(3.14159 / 2),
                            child: Image.asset(
                                'assets/${shipOnCell.size}-$shipPart.png'))
                        : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
