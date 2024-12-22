import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_warships/core/features/widgets/column_numbers.dart';
import 'package:test_warships/core/features/widgets/game_background.dart';
import 'package:test_warships/core/features/widgets/game_board.dart';
import 'package:test_warships/core/features/widgets/list_ships.dart';
import 'package:test_warships/core/features/widgets/row_buttons.dart';
import 'package:test_warships/core/features/widgets/row_letters.dart';
import 'package:test_warships/core/viewmodels/game_viewmodel.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final cellSize = size.width / 11;
    final viewModelNotifier = ref.read(gameStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Розміщення кораблів'),
        actions: [
          IconButton(
            onPressed: viewModelNotifier.clearBoard,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          const GameBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              children: [
                RowLetters(cellSize: cellSize),
                const SizedBox(height: 5),
                SizedBox(
                  height: cellSize * 10,
                  child: Row(
                    children: [
                      ColumnNumbers(cellSize: cellSize),
                      const SizedBox(
                        width: 5,
                      ),
                      const GameBoard(),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const ListShips(),
                const SizedBox(height: 60),
                const RowButtons()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
