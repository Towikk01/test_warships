import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_warships/core/features/widgets/button.dart';
import 'package:test_warships/core/features/widgets/ship_widget.dart';
import 'package:test_warships/core/models/ship.dart';
import 'package:test_warships/core/viewmodels/game_viewmodel.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(gameStateProvider);
    final viewModelNotifier = ref.read(gameStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Розстановлення кораблів'),
        actions: [
          IconButton(
            onPressed: viewModelNotifier.clearBoard,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/water.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Game Board
                SizedBox(
                  height: 400,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                          final isValidDrop = candidateData.isNotEmpty &&
                              (candidateData.first!.positions.isNotEmpty &&
                                      candidateData.first?.positions[0] ==
                                          shipOnCell?.positions[0] ||
                                  viewModelNotifier.canPlaceShip(
                                      candidateData.first!,
                                      x,
                                      y,
                                      candidateData.first!.isHorizontal));
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
                                      color: Colors.red,
                                      child: Transform.rotate(
                                          angle: !shipOnCell.isHorizontal
                                              ? 0
                                              : -(3.14159 / 2),
                                          child: Image.asset(
                                              'assets/${shipOnCell.size}-$shipPart.png')),
                                    )
                                  : Container(color: Colors.blueAccent),
                              child: Container(
                                margin:
                                    EdgeInsets.all(shipOnCell == null ? 1 : 0),
                                decoration: BoxDecoration(
                                  color: isOccupied
                                      ? Colors.red
                                      : Colors.blueAccent,
                                  border: isValidDrop
                                      ? Border.all(
                                          color: Colors.green, width: 2)
                                      : null,
                                ),
                                child: shipOnCell != null
                                    ? Transform.rotate(
                                        angle: !shipOnCell.isHorizontal
                                            ? 0
                                            : -(3.14159 / 2),
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
                ),
                // Ship Selection Area
                SizedBox(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: viewModel.ships
                        .where((ship) => !ship.isPlaced)
                        .map((ship) {
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
                ),
                const SizedBox(height: 20),
                // Control Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Button(
                      text: 'Авто',
                      onPressed: viewModelNotifier.autoPlaceShips,
                      color: Colors.blue,
                      padding: 18,
                    ),
                    Button(
                      onPressed: viewModel.areAllShipsPlaced ? () {} : null,
                      text: 'Почати',
                      color: Colors.greenAccent,
                      padding: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
