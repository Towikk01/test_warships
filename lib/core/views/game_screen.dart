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
        ),
        body: Stack(children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), // Adjust darkness here
                BlendMode.darken, // Applies the black overlay
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
                      return DragTarget<Ship>(
                        onAcceptWithDetails: (details) {
                          final ship = details.data;
                          if (viewModelNotifier.canPlaceShip(
                              ship, x, y, ship.isHorizontal)) {
                            viewModelNotifier.placeShip(
                                ship, x, y, ship.isHorizontal);
                          }
                        },
                        builder: (context, candidateData, rejectedData) {
                          final isOccupied = viewModel.board[x][y] != 0;
                          final ship = viewModel.ships.firstWhere(
                              (ship) => ship.positions.contains(x * 10 + y),
                              orElse: () => Ship(size: 0));
                          return GestureDetector(
                            onTap: () {
                              viewModelNotifier.rotateShip(ship);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(1),
                              color:
                                  !isOccupied ? Colors.blueAccent : Colors.red,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
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
                        child: GestureDetector(
                          onDoubleTap: () {},
                          child: ShipWidget(ship: ship),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                      color: viewModel.areAllShipsPlaced
                          ? Colors.greenAccent
                          : Colors.black,
                      padding: 18,
                    ),
                    Button(
                      onPressed: viewModelNotifier.clearBoard,
                      color: Colors.red,
                      padding: 18,
                      text: 'Скинути',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ]));
  }
}
