import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_warships/core/models/ship.dart';
import 'dart:math';

class GameViewModel extends ChangeNotifier {
  final List<Ship> ships = [
    Ship(size: 4),
    Ship(size: 3),
    Ship(size: 3),
    Ship(size: 2),
    Ship(size: 2),
    Ship(size: 2),
    Ship(size: 1),
    Ship(size: 1),
    Ship(size: 1),
    Ship(size: 1),
  ];

  List<List<int>> board = List.generate(10, (_) => List.filled(10, 0));

  void autoPlaceShips() {
    clearBoard();
    final random = Random();

    for (var ship in ships) {
      bool placed = false;
      while (!placed) {
        final x = random.nextInt(10);
        final y = random.nextInt(10);
        final isHorizontal = random.nextBool();
        if (canPlaceShip(ship, x, y, isHorizontal)) {
          placeShip(ship, x, y, isHorizontal);
          placed = true;
        }
      }
    }
    notifyListeners();
  }

  void removeShip(Ship ship) {
    for (int i = 0; i < ship.size; i++) {
      final x = ship.positions[i] ~/ 10;
      final y = ship.positions[i] % 10;
      board[x][y] = 0;
    }
    ship.isPlaced = false;
    ship.positions.clear();
    notifyListeners();
  }

  void clearBoard() {
    board = List.generate(10, (_) => List.filled(10, 0));
    for (var ship in ships) {
      ship.isPlaced = false;
      ship.isHorizontal = false;
      ship.positions.clear();
    }
    notifyListeners();
  }

  bool canPlaceShip(Ship ship, int x, int y, bool isHorizontal) {
    for (int i = 0; i < ship.size; i++) {
      final newX = isHorizontal ? x : x + i;
      final newY = isHorizontal ? y + i : y;

      if (newX >= 10 || newY >= 10 || board[newX][newY] != 0) {
        return false;
      }

      for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
          final checkX = newX + dx;
          final checkY = newY + dy;

          if (checkX >= 0 &&
              checkX < 10 &&
              checkY >= 0 &&
              checkY < 10 &&
              board[checkX][checkY] != 0) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void rotateShip(Ship ship) {
    if (ship.positions.isEmpty) return;
    final x = ship.positions[0] ~/ 10;
    final y = ship.positions[0] % 10;
    final isHorizontal = !ship.isHorizontal;
    removeShip(ship);
    if (canPlaceShip(ship, x, y, isHorizontal)) {
      placeShip(ship, x, y, isHorizontal);
    } else {
      placeShip(ship, x, y, !isHorizontal);
    }
  }

  void placeShip(Ship ship, int x, int y, bool isHorizontal) {
    for (int i = 0; i < ship.size; i++) {
      final newX = isHorizontal ? x : x + i;
      final newY = isHorizontal ? y + i : y;
      board[newX][newY] = 1;
    }
    ship.isPlaced = true;
    ship.isHorizontal = isHorizontal;
    ship.positions = List.generate(
      ship.size,
      (i) => isHorizontal ? x * 10 + y + i : (x + i) * 10 + y,
    );

    notifyListeners();
  }

  bool get areAllShipsPlaced => ships.every((ship) => ship.isPlaced);
}

final gameStateProvider = ChangeNotifierProvider<GameViewModel>((ref) {
  return GameViewModel();
});
