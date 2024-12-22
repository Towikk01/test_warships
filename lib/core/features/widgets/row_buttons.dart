import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_warships/core/features/widgets/button.dart';
import 'package:test_warships/core/viewmodels/game_viewmodel.dart';

class RowButtons extends ConsumerWidget {
  const RowButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(gameStateProvider);

    final viewModelNotifier = ref.read(gameStateProvider.notifier);
    return Row(
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
    );
  }
}
