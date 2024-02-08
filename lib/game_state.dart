import 'dart:math';

import 'package:equatable/equatable.dart';

sealed class GameState extends Equatable {
  GameBoard gameBoard;

  GameState(this.gameBoard);

  @override
  List<Object> get props => [gameBoard];
}

final class GameNew extends GameState {
  GameNew(super.gameBoard);
}

final class GameRunning extends GameState {
  GameRunning(super.gameBoard);
}

final class GameOver extends GameState {
  GameOver(super.gameBoard);
}

class GameBoard extends Equatable {
  // Row, column where 0,0 is the top left of the 4x4 grid.
  static const coordinates = [
    (0, 0),
    (0, 1),
    (0, 2),
    (0, 3),
    (1, 0),
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 0),
    (2, 1),
    (2, 2),
    (2, 3),
    (3, 0),
    (3, 1),
    (3, 2),
    (3, 3)
  ];
  static final _random = Random();

  GameBoard();

  List<List<int?>> grid =
      List<List<int?>>.filled(4, List<int?>.filled(4, null));

  @override
  List<Object?> get props => [grid];

  void addTwo() {
    final emptyCoordinates =
        coordinates.where((p) => grid[p.$1][p.$2] == null).toList();
    var selectedCoordinates =
        emptyCoordinates[_random.nextInt(emptyCoordinates.length)];
    grid[selectedCoordinates.$1][selectedCoordinates.$2] = 2;
  }
}
